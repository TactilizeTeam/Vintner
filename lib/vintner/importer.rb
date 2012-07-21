module Vintner
  class Importer
    include DSLMethods

    def import representer, model, hash
      @representer = representer
      @model = model

      # Registering keys and properties
      @block.call(self) if @block

      # Then we play the score accordingly
      @store.each do |key, importer_or_property|
        if importer_or_property.is_a? Importer
          importer_or_property.import representer, model, hash[key.to_s]
        else
          importer_or_property.import model, hash[key.to_s]
        end
      end

      hash
    end
  end
end
