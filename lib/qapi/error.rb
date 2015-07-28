module Qapi
  class Error < RuntimeError
    def initialize(body)
      @body = JSON(body)
    end

    def message
      @body['problem']
    end

    def details
      @body['details']
    end
  end
end
