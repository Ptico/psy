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

      def env; @_env; end

      def request; @_request; end

      def response; @_response; end

      def call; end

      def to_rack_array
        response.to_rack_array
      end

    private

      def initialize(request, response)
        @_env      = request.env
        @_request  = request
        @_response = response
      end

    end
  end
end
