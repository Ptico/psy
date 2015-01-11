module Psy
  class Response

    def status=(status)
      @status = Tipi::Status[status.to_i]
      @body = [] unless body_allowed?
    end

    def body=(body)
      @body = Array(body) if body_allowed?
    end

    def add_header(key, value)
      @headers[key] = value
    end

    def to_rack_array
      [@status.to_i, @headers, @body]
    end

  private

    def initialize(env)
      @request_method = Tipi::Method[env[Rack::REQUEST_METHOD]]

      self.status = 200

      @body = []
      @headers = {}
    end

    def body_allowed?
      @status.allows_body? && @request_method.allows_body?
    end
  end
end
