require "date"
require "wip"
require "wip/client"

class Wip::Todo
  attr_accessor :id, :body, :completed_at
  attr_reader :client

  def self.find(id)
    client = Wip::Client.new
    find_query = %{
      {
        todo(id: \"#{id}\") {
          id
          body
          completed_at
        }
      }
    }
    client.request find_query
    parse client.data("todo")
  end

  def self.create(body:, completed_at: nil)
    new(body: body, completed_at: completed_at).tap &:save
  end

  def self.parse(data)
    todo_id = data["id"].to_i
    completed_at = DateTime.parse(data["completed_at"]) unless data["completed_at"].nil?
    new id: todo_id, body: data["body"], completed_at: completed_at
  end

  def self.complete(id)
    todo = find id
    todo.complete
    todo
  end


  def initialize(id: nil, body: nil, completed_at: nil)
    @id = id
    @body = body
    @completed_at = completed_at
  end


  def client
    @client ||= Wip::Client.new
  end

  def description
    [icon, body, "##{id}"].join " "
  end

  def done?
    !completed_at.nil?
  end

  def icon
    done? ? "✅" : "🚧"
  end

  def complete
    client.request complete_query
    client.data("completeTodo").tap do |params|
      @completed_at = DateTime.parse params["completed_at"]
    end
  end

  def save
    client.request create_query
    client.data("createTodo").tap do |params|
      @id = params["id"]&.to_i
    end
  end

  private
    def create_query
      %{
        mutation createTodo {
          createTodo(input: {#{to_params}}) {
            id
            body
            completed_at
          }
        }
      }
    end

    def complete_query
      %{
        mutation completeTodo {
          completeTodo(id: #{id}) {
            id
            body
            completed_at
          }
        }
      }
    end

    def to_params
      [:body, :completed_at].collect do |key|
        value = send(key).nil? ? "null" : "\"#{send(key)}\""
        [key, value].join(": ")
      end.join(", ")
    end
end