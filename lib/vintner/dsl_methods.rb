module Vintner
  module DSLMethods
    def initialize &block
      @store = {}
      @block = block
    end

    def method_missing method_id, *args, &block
      if args.length > 0 && !block_given?
        @store[method_id] = args.first
      else
        @store[method_id] = self.class.new(&block)
      end
    end

    def property name
      @store[name] = @representer.properties[name.to_sym]
    end

    def collection name
      if @representer.represents_model?
        @store[name] = @representer.collections[name.to_sym]
      else
        @store[name] = @representer.collection
      end
    end
  end
end
