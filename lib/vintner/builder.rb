module Vintner
  class Builder
    include DSLMethods

    def export representer, model
      @store = {}
      @representer = representer
      @model = model

      # Registering keys and properties
      @block.call(self, @model) if @block

      hash = {}

      # Then we play the score accordingly
      @store.each do |key, object|
        if object.is_a? Builder
          hash[key] = object.export(representer, model)
        else
          if object.respond_to? :export
            hash[key] = object.export(@model)
          else
            hash[key] = object
          end
        end
      end

      hash
    end
  end
end
