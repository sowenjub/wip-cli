require "date"
require "thor"
require "wip"
require "wip/todo"

class Wip::CLI < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"

  desc "complete [ID]", "Mark a todo as completed"
  def complete(todo_id)
    todo = Wip::Todo.complete(todo_id)
    puts todo.description
  end

  desc "done [BODY]", "Create a new todo and immediately mark it as completed"
  def done(body)
    todo = Wip::Todo.create(body: body, completed_at: DateTime.now)
    puts todo.description
  end

  desc "todo [BODY]", "Create a new todo"
  def todo(body)
    todo = Wip::Todo.create(body: body)
    puts todo.description
  end

  desc "todos", "List viewer todos"
  method_option :completed, type: :boolean, aliases: '-c', default: nil
  method_option :filter, type: :string, aliases: '-f', default: nil
  method_option :limit, type: :numeric, aliases: '-l', default: 5
  method_option :order, type: :string, aliases: '-o', default: "completed_at:desc"
  def todos
    user = Wip::User.viewer(todos: options.slice("completed", "filter", "limit", "order"))
    user.todos.each do |todo|
      puts todo.description
    end
  end
end