
module Qapi
  class Query
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end
  end
end
