
module Qapi
  class Model
    attr_reader :connection

    class << self
      attr_accessor :attrs
    end

    def self.attribute(name)
      puts "Deprecated"
      #self.send(:attr_accessor, name)
      #self.attrs ||= []
      #self.attrs << name.to_s
    end

    def self.parse(connection, json)
      object = JSON(json)
      if object.kind_of?(Array)
        object.map { |obj| new(connection, obj) }
      else
        new(connection, object)
      end
    end

    def initialize(connection, attrs = {})
      # TODO: Handle nested hashes with 'associated' objects
      @connection = connection
      @attrs = attrs
    end

    def method_missing(method, *args, &block)
      if method.to_s =~ /=$/
        @attrs[method.to_s[0...-1]] = args[0]
      else
        @attrs.fetch(method.to_s) # TODO: Use our own exception
      end
    end

    def inspect
      @attrs
      #"<" + self.class.attrs.map do |attr|
      #  "#{attr}: #{send(attr)}"
      #end.join(", ") + ">"
    end
  end
end
