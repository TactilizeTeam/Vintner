module Vintner
  module DSLMethods
    def initialize &block
      @store = {}
      @block = block
    end

    def method_missing method_id, *args, &block
      @store[method_id] = self.class.new(&block)
    end

    def property name
      @store[name] = @representer.properties[name.to_sym]
    end
  end
end
