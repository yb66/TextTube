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

    # @!attribute [rw] options
    #   This instance's options.
    #   @return [Hash]
    attr_accessor :options

    # @param [#to_s] text The original text.
    # @param [Hash] options Options that will be passed on to every instance.
    # @example
    #   n = NeuS.new "abc"
    def initialize( text, options={} )
      @options = options
      @filters ||= []
      super text
    end


    class << self

      # Global options. Every descendant will get these.
      def options
        @options ||= {}
      end

      # remove all filters
      # @todo remove methods too.
      def reset!
        @filters = []
      end


      # Filters added.
      def filters
        @filters ||= []
      end


      # Register a module of filters.
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
      #
      # I could've made it so there's no need to write the
      # `filter_with` part, but this way your code will be 
      # clearer to those reading it later, and you can add 
      # in any other stuff you want done too, you don't just 
      # have to set up a filter.
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


      # A clean slate
      # @private
      def inherited(subclass)
        subclass.reset!
      end
    end


    # Run the filters. If the names of filters are provided as arguments then only those filters will be run, in that order (left first, to right).
    # @overload filter()
    #   Run all the filters in the order they were registered.
    #     n = NeuS.new "abc"
    #     n.filter
    #     # => "---a b ca b ca b ca b ca b ca b c---"
    # @overload filter( filters )
    #   Run the given filters in the order given.
    #   @param [Array<#to_sym>] filters
    #   @example
    #     n = NeuS.new "abc"
    #     n.filter :spacial
    #     # => "a b c"
    #     n.filter :spacial, :dashes
    #     # => "---a b c---"
    # @overload filter( filters_and_options )
    #   Run the given filters in the order given with the given options. Pass any options for a filter at the end, by giving the options as a hash with the name of the filter. I'd prefer to give the filter name and the options at the same time, but the Ruby argument parser can't handle it, which is fair enough :)
    #   @example
    #     n = NeuS.new "abc"
    #     n.filter :dashes, :spacial, :dashes => {some_option_for_dashes: true}
    def filter( *order_and_options )
      if order_and_options.last.respond_to?(:keys)
        *order,options = *order_and_options
      else
        order,options = order_and_options, {}
      end
      order = order.flatten
      order = @options.fetch :order, self.class.filters if order.empty?
      order.inject(self){|current,filter|
        send filter, current, options
      }
    end

    # See all added filters.
    def filters
      self.class.filters
    end

  end
end