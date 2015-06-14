module TextTube

  # Add this to your filter module.
  # @example
  #   module AFilter
  #     extend TextTube::Filterable
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
    # @return [Array<Symbol>]
    def filters
      @filters ||= []
    end
  
    # Add a filter.
    # @example
    #   filter_with :triple do |text|
    #     text * 3
    #   end
    #   filter_with :number do |text,options|
    #     text * options[:times].to_i
    #   end
    # @param [#to_sym] name
    # @yield [String, Hash] Pass the string to be filtered, and optionally, any options.
    def filter_with name, &block
      name = name.to_sym
      filters << name unless filters.include? name
      define_method name do |current=self, options=nil|
        options = [options, @options, self.class.options].find{|opts|
          !opts.nil? && 
          opts.respond_to?(:keys) && 
          !opts.empty?
        } || {}

        block.call current, options[name]
      end
    end

  end # Filterable
end # TextTube