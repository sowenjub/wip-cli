require "date"
require "thor"
require "wip"
require "wip/todo"

class Wip::CLI < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"

  desc "complete [ID]", "Mark a todo as completed"
  method_option :undo, type: :boolean, aliases: '-u'
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

  desc "todo [BODY]", "Create a new todo"
  def todo(body)
    todo = Wip::Todo.create(body: body)
    puts todo.description
  end

  desc "todos", "List viewer todos"
  method_option :completed, type: :boolean, aliases: '-c'
  method_option :filter, type: :string, aliases: '-f'
  method_option :limit, type: :numeric, aliases: '-l', default: 5
  method_option :order, type: :string, aliases: '-o', default: "completed_at:desc"
  method_option :username, type: :string, aliases: '-u'
  def todos
    todos_options = options.slice("completed", "filter", "limit", "order")
    user = options.username.nil? ? Wip::User.viewer(todos: todos_options) : Wip::User.find(username: options.username, todos: todos_options)
    user.todos.each do |todo|
      puts todo.description
    end
  end
end