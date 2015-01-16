module Psy
  module Controller
    class Base
      def self.call(env)
        request  = ::Rack::Request.new(env)
        response = Response.new(env)

        instance = new(request, response)
        instance.call
        instance.to_rack_array
      end

      ##
      # Controller environment
      #
      def env; @_env; end

      ##
      # Request object
      #
      def request; @_request; end

      ##
      # Response builder
      #
      def response; @_response; end

      ##
      # Abstract: Method for main processing logic
      # should be overrided in descendants
      def call; end

      def to_rack_array
        response.to_rack_array
      end

    private

      def initialize(request, response, env)
        @_env      = env
        @_request  = request
        @_response = response
      end

    end
  end
end
