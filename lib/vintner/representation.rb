module Vintner
  class Representation
    def initialize &block
      @builder = Builder.new &block
    end

    def export representer, model
      @builder.export representer, model
    end
  end

  class Builder
    def initialize &block
      @store = {}
      @block = block
    end

    def export representer, model
      @representer = representer
      @model = model

      # Registering keys and properties
      @block.call(self) if @block

      hash = {}

      # Then we play the score accordingly
      @store.each do |key, builder|
        if builder.is_a? Builder
          hash[key] = builder.export(representer, model)
        else
          hash[key] = builder
        end
      end

      hash
    end

    def property name
      @store[name] = @representer.properties[name.to_sym].export(@model)
    end

    def method_missing method_id, *args, &block
      @store[method_id] = self.class.new(&block)
    end
  end
end
