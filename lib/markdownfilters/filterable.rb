module MarkdownFilters

  # Add this to your filter module.
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
  module Filterable

    # See all current filters.
    def filters
      @filters ||= []
    end
  
    # Add a filter.
    # @example
    #   filter_with :triple do |text|
    #     text * 3
    #   end
    def filter_with name, &block
      filters << name unless filters.include? name
      define_method name do |current=self, options=nil|
        if current.respond_to? :keys
          options=current
          current=self
        end
        block.call current, options
      end
    end

  end # Filterable
end # MarkdownFilters