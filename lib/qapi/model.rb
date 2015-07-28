
module Qapi
  class Model
    attr_reader :connection

    class << self
      attr_accessor :attrs
    end

    def self.attribute(name)
      self.send(:attr_accessor, name)
      self.attrs ||= []
      self.attrs << name.to_s
    end

    def initialize(connection, attrs = {})
      @connection = connection
      self.class.attrs.each do |attr|
        self.send("#{attr}=", attrs[attr])
      end
    end

    def inspect
      "<" + self.class.attrs.map do |attr|
        "#{attr}: #{send(attr)}"
      end.join(", ") + ">"
    end
  end
end
