require 'support/requests/request'

module Support
  module Requests
    class GeneralRequest < Request
      attr_accessor :title, :url, :additional, :user_agent

      def self.label
        "General"
      end

      def self.description
        "Report a problem, request GDS support, or make a suggestion"
      end
    end
  end
end
