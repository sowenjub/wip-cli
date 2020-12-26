# frozen_string_literal: true

module Wip
  class Auth
    def self.api_key
      ENV["WIP_API_KEY"]
    end
  end
end
