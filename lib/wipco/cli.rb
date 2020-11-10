require "date"
require "thor"
require "wipco"
require "wipco/todo"

class Wipco::CLI < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"

  desc "complete [ID]", "Mark a todo as completed"
  def complete(todo_id)
    todo = Wipco::Todo.complete(todo_id)
    puts todo.description
  end

  desc "done [BODY]", "Create a new todo and immediately mark it as completed"
  def done(body)
    todo = Wipco::Todo.create(body: body, completed_at: DateTime.now)
    puts todo.description
  end

  desc "todo [BODY]", "Create a new todo"
  def todo(body)
    todo = Wipco::Todo.create(body: body)
    puts todo.description
  end
end