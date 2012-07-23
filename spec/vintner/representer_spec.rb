require 'spec_helper'

module Vintner
  describe Representer do
    it "should declare a simple property" do
      class Dummy
        include Vintner::Representer

        property :title
      end

      Dummy.properties.should include(:title)
    end

    it "should declare a property with a getter" do
      class Dummy
        include Vintner::Representer

        property :title do
          get do |model|
            model.formatted_title
          end
        end
      end


      Dummy.properties[:title].getter_defined?.should be(true)
    end

    it "should declare a property with a setter" do
      class Dummy
        include Vintner::Representer

        property :title do
          set do |model, value|
            model.formatted_title = value
          end
        end
      end

      Dummy.properties[:title].setter_defined?.should be(true)
    end

    describe "Representation" do
      before :each do
        class Dummy
          include Vintner::Representer

          property :title do
            get do |model|
              model.formatted_title
            end

            set do |model, value|
              model.formatted_title = value
            end
          end

          representation do |json|
            json.meta do |meta|
              meta.property :title
            end
          end
        end
      end

      it "should declare a representation" do
        Dummy.representation.should_not be_nil
      end

      it "should export json" do
        hash = {meta:{title:"some title"}}

        model = Struct.new(:formatted_title).new("some title")
        Dummy.new(model).to_json.should ==(hash.to_json)
      end

      it "should import json" do
        hash = {meta:{title:"some title"}}
        model = Struct.new(:formatted_title).new

        Dummy.new(model).from_json(hash.to_json).formatted_title.should ==("some title")
      end
    end

    describe "Complex representation" do
      before :each do
        class Dummy
          include Vintner::Representer

          property :title do
            get do |model|
              model.formatted_title
            end

            set do |model, value|
              model.formatted_title = value
            end
          end

          property :position do
            get do |model|
              {:x => model.position_x, :y => model.position_y}
            end

            set do |model, value|
              model.position_x = value['x']
              model.position_y = value['y']
            end
          end

          representation do |json|
            json.meta do |meta|
              meta.property :title
            end

            json.property :position
          end
        end
      end

      it "should export json" do
        hash = {:meta=>{:title => "test"}, :position => {:x => 4, :y => 5}}

        model = Struct.new(:formatted_title, :position_x, :position_y).new("test", 4,5)

        Dummy.new(model).to_json.should ==(hash.to_json)
      end

      it "should import json" do
        hash = {:meta=>{:title => "test"}, :position => {:x => 4, :y => 5}}

        model = Struct.new(:formatted_title, :position_x, :position_y).new

        @model = Dummy.new(model).from_json(hash.to_json)
        @model.formatted_title.should ==("test")
        @model.position_x.should ==(4)
        @model.position_y.should ==(5)
      end
    end

    describe "Immediate values" do
      before :each do
        @hash = {:meta=>{:version => 4, :title => "test", :stuff => "stuff"}}
        @model = Struct.new(:formatted_title, :stuff).new("test", "stuff")

        class Dummy
          include Vintner::Representer

          property :title do
            get do |model|
              model.formatted_title
            end

            set do |model, title|
              model.formatted_title = title
            end
          end

          representation do |json, model|
            json.meta do |meta|
              meta.version 4
              meta.property :title
              meta.stuff model.stuff
            end
          end
        end
      end

      it "should export immediate values " do
        Dummy.new(@model).to_json.should ==(@hash.to_json)
      end

      it "should ignore it when importing" do
        Dummy.new(@model).from_json(@hash.to_json).formatted_title.should ==('test')
      end
    end
  end

  describe "Collections" do
    before :each do
      class Dummy
        include Vintner::Representer

        property :title do
          get do |model|
            model.formatted_title
          end

          set do |model, value|
            model.formatted_title = value
          end
        end

        representation do |json|
          json.meta do |meta|
            meta.property :title
          end
        end
      end

      class DummyCollection
        include Vintner::Representer

        collection :dummies, Dummy do
          get { |model| model.dummies }
        end

        representation do |json|
          json.meta do |meta|
            meta.page 0
            meta.total_pages 4
          end

          json.collection :dummies
        end
      end

      @a = {:meta=>{:title => "test"}}
      @b = {:meta=>{:title => "test2"}}

      @collection_klass = Struct.new(:dummies)
      @model_klass = Struct.new(:formatted_title)
      @collection = @collection_klass.new [@model_klass.new("test"), @model_klass.new("test2")]

      @hash = {
        :meta => {
        :page => 0,
        :total_pages => 4
      },
        :dummies => [@a, @b]
      }
    end

    it "should export the collection" do
      DummyCollection.new(@collection).to_json.should ==(@hash.to_json)
    end
  end
end
