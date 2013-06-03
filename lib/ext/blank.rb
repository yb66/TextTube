# encoding: UTF-8

module MarkdownFilters
  module CoreExtensions
  
    def blank?
      respond_to?(:empty?) ? 
        empty? :
        !self
    end
  end
end

class Hash
  include MarkdownFilters::CoreExtensions
end