require "wip"

class Wip::Auth
  def self.api_key
    ENV['WIP_API_KEY']
  end
end