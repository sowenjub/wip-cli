# frozen_string_literal: true

require "date"
require "thor"
require "tty-prompt"
require "tzinfo"
require "wip"
require "wip/todo"
require "byebug"

class Wip::CLI < Thor
  class_option :verbose, type: :boolean, aliases: "-v"

  desc "complete [ID]", "Mark a todo as completed"
  method_option :undo, type: :boolean, aliases: "-u"
  def complete(todo_id)
    todo = options.undo ? Wip::Todo.uncomplete(todo_id) : Wip::Todo.complete(todo_id)
    puts todo.description
  end

  desc "done [BODY]", "Create a new todo and immediately mark it as completed"
  def done(body)
    todo = Wip::Todo.create(body: body, completed_at: DateTime.now)
    puts todo.description
  end

  desc "delete [ID]", "Delete a todo"
  def delete(todo_id)
    todo = Wip::Todo.delete(todo_id)
    puts todo.description
  end

  desc "me", "Outputs your profile summary"
  def me
    print_user_profile Wip::User.viewer(todos: { "order" => "created_at:desc" })
  end

  desc "todo [BODY]", "Create a new todo"
  def todo(body)
    todo = Wip::Todo.create(body: body)
    puts todo.description
  end

  desc "todos", "List viewer todos"
  method_option :completed, type: :boolean, aliases: "-c", desc: "Filter by status"
  method_option :filter, type: :string, aliases: "-f"
  method_option :interactive, type: :boolean, aliases: "-i", default: false, desc: "Toggle todos statuses by selecting them"
  method_option :limit, type: :numeric, aliases: "-l", default: 5
  method_option :order, type: :string, aliases: "-o", default: "created_at:desc"
  method_option :username, type: :string, aliases: "-u"
  def todos
    todos_options = options.slice("completed", "filter", "limit", "order")
    user = options.username.nil? ? Wip::User.viewer(todos: todos_options) : Wip::User.find(username: options.username, todos: todos_options)
    if options.interactive
      prompt = TTY::Prompt.new
      options = user.todos.inject({}) do |h, todo|
        h[todo.description] = todo.id
        h
      end
      choice = prompt.multi_select("Toggle todos?", options, per_page: todos_options["limit"])
      puts "No change" if choice.empty?
      choice.each do |todo_id|
        todo = user.todos.find { |task| task.id == todo_id }
        todo.toggle
        puts todo.description
      end
    else
      user.todos.each { |todo| puts todo.description }
    end
  end

  desc "user [ID] or [USERNAME]", "Outputs a profile summary"
  def user(identifier)
    user = identifier.to_i > 0 ? Wip::User.find(identifier.to_i) : Wip::User.find(username: identifier)
    print_user_profile user
  end

  no_commands {
    def print_user_profile(user)
      puts "👤 #{user.name}, aka @#{user.username} (User #{user.id})"
      puts "🌍 Lives in #{user.time_zone} where it currently is #{user.tz.to_local(Time.now).strftime("%H:%M")}"
      puts "✅ #{user.completed_todos_count} completed todos"
      if user.streaking
        puts "#{user.streak_icon} On a streak of #{user.streak}"
      else
        last_todo = user.done_todos.first
        if last_todo.nil?
          puts "#{user.streak_icon} No todo"
        else
          puts "#{user.streak_icon} Last todo created @ #{last_todo.created_at}"
        end
      end
      puts "🔗 #{user.url}"
    end
  }
end
