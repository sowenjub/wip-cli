# frozen_string_literal: true

module Wip
  class GraphqlHelper
    def self.query_conditions(**args)
      return "" if args.empty?
      args.collect do |k, v|
        value = v.kind_of?(String) ? "\"#{v}\"" : v
        [k, value].join(":")
      end.join(", ").yield_self { |s| "(%s)" % s }
    end
  end
end
