require "date"
require "wip"
require "wip/client"

class Wip::User
  attr_accessor :avatar_url, :best_streak, :completed_todos_count, :first_name, :id, :last_name, :streak, :streaking, :time_zone, :url, :username, :todos

  def self.default_selection
    %{
      avatar_url
      best_streak
      completed_todos_count
      first_name
      id
      last_name
      streak
      streaking
      time_zone
      todos {#{Wip::Todo.default_selection}}
      url
      username
    }
  end

  def self.viewer
    client = Wip::Client.new
    find_query = %{
      {
        viewer {#{default_selection}}
      }
    }
    client.request find_query
    parse client.data("viewer")
  end

  def self.find(id)
    client = Wip::Client.new

    find_query = %{
      {
        user(id: #{id}) {#{default_selection}}
      }
    }
    client.request find_query
    parse client.data("user")
  end

  def initialize(avatar_url: nil, best_streak: nil, completed_todos_count: nil, first_name: nil, id: nil, last_name: nil, streak: nil, streaking: nil, time_zone: nil, url: nil, username: nil, todos: [])
    @avatar_url = avatar_url
    @best_streak = best_streak
    @completed_todos_count = completed_todos_count
    @first_name = first_name
    @id = id
    @last_name = last_name
    @streak = streak
    @streaking = streaking
    @time_zone = time_zone
    @url = url
    @username = username
    @todos = todos
  end

  def self.parse(data)
    new.tap do |user|
      data.each do |key, raw_value|
        value = case key
        when "id"
          raw_value.to_i
        when "todos"
          raw_value.collect { |v| Wip::Todo.parse v }
        else
          raw_value
        end
        user.send("#{key}=", value)
      end
    end
  end
end