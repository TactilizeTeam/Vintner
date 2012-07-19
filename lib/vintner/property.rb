module Vintner
  class Property
    attr_reader :name

    def initialize name, &block
      @name = name

      instance_eval &block if block_given?
    end

    def import model, value
      yield mode, value
    end

    def export model
      yield model
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
