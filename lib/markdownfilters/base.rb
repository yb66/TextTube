module MarkdownFilters

  # Inherit from this and wrap it around a string and
  # you can then run filters against it.
  # @example
  #   module AFilter
  #     extend MarkdownFilters::Filterable
  #   
  #     filter_with :double do |text|
  #       text * 2
  #     end
  #   
  #     filter_with :triple do |text|
  #       text * 3
  #     end
  #   end
  #   
  #   module BFil
  #     extend MarkdownFilters::Filterable
  #   
  #     filter_with :spacial do |current,options|
  #       current.split(//).join " " 
  #     end
  #   end
  #   
  #   class NeuS < MarkdownFilters::Base
  #     register BFil
  #     register AFilter
  #     register do
  #       filter_with :dashes do |text|
  #         "---#{text}---"
  #       end
  #     end
  #   end
  #
  #   n = NeuS.new "abc"
  #   n.filter
  #   # => "---a b ca b ca b ca b ca b ca b c---"
  #   n
  #   # => "abc"
  class Base < ::String
  
    DEFAULT_OPTIONS = {}
    attr_accessor :config

    # @param [#to_s] text The original text.
    # @param [Hash] options
    def initialize( text, options={} )
      @config = DEFAULT_OPTIONS.merge options
      @filters ||= []
      super text
    end


    class << self

      # remove all filters
      # @todo remove methods too.
      def reset!
        @filters = []
      end


      # Filters added.
      def filters
        @filters ||= []
      end


      # Register a module of filters
      # @example
      #   class MyFilter < MarkdownFilters::Base
      #     register MarkdownFilters::LinkReffing
      #     register MarkdownFilters::Coderay
      #     register do
      #       filter_with :dashes do |text|
      #         "---#{text}---"
      #       end
      #     end
      #   end
      def register( filter=nil, &block )
        @filters ||= []
        if block
          name = filter
          
          filter = Module.new do
            extend Filterable
          end
          filter.instance_eval &block
        end
        @filters += filter.filters
        include filter
      end

    
      def inherited(subclass)
        subclass.reset!
      end
    end


    # Run the filters. If the names of filters are provided as arguments then only those filters will be run, in that order (left first, to right).
    # @example
    #   n = NeuS.new "abc"
    #   n.filter
    #   # => "---a b ca b ca b ca b ca b ca b c---"
    #   n.filter :spacial
    #   # => "a b c"
    #   n.filter :spacial, :dashes
    #   # => "---a b c---"
    #   n.filter :dashes, :spacial
    #   # => "- - - a b c - - -"
    def filter( *order )
      order = order.flatten
      order = @config.fetch :order, self.class.filters if order.empty?
      order.inject(self){|current,(filter,options)|
        send filter, current, options
      }
    end

    # See all added filters.
    def filters
      self.class.filters
    end

  end
end