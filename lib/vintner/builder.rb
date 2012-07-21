module Vintner
  class Builder
    include DSLMethods

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
          hash[key] = builder.export(@model)
        end
      end

      hash
    end
  end
end
