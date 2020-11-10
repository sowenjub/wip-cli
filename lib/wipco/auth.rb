require "wipco"

class Wipco::Auth
  def self.api_key
    ENV['WIPCO_API_KEY']
  end
end