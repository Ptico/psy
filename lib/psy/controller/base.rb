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

      attr_reader :env

      attr_reader :request

      attr_reader :response

      def call; end

      def to_rack_array
        response.to_rack_array
      end

    private

      def initialize(request, response)
        @env      = request.env
        @request  = request
        @response = response
      end

    end
  end
end
