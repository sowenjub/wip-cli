require "date"
require "wip"
require "wip/client"

class Wip::User
  attr_accessor :avatar_url, :best_streak, :completed_todos_count, :first_name, :id, :last_name, :streak, :streaking, :time_zone, :url, :username

  def self.viewer
    client = Wip::Client.new
    find_query = %{
      {
        viewer {
          avatar_url
          best_streak
          completed_todos_count
          first_name
          id
          last_name
          streak
          streaking
          time_zone
          url
          username
        }
      }
    }
    client.request find_query
    parse client.data("viewer")
  end

  def initialize(avatar_url: nil, best_streak: nil, completed_todos_count: nil, first_name: nil, id: nil, last_name: nil, streak: nil, streaking: nil, time_zone: nil, url: nil, username: nil)
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
  end

  def self.parse(data)
    new.tap do |user|
      data.each do |key, value|
        user.send("#{key}=", key == "id" ? value.to_i : value)
      end
    end
  end
end