module Vintner
  class Collection
    def initialize name, representer, &block
      @name = name
      @representer = representer

      instance_eval &block if block_given?
    end

    def import
      raise "TODO"
    end

    def export collection
      if getter_defined?
        result = @getter.call collection
      else
        result = collection
      end

      wrap_representers result
    end

    def wrap_representers collection
      collection.map do |item|
        @representer.export(item)
      end
    end

    def getter_defined?
      !!@getter
    end

    def setter_defined?
      !!@setter
    end

    private
    def get &block
      @getter = block
    end

    def set &block
      @setter = block
    end
  end
end

