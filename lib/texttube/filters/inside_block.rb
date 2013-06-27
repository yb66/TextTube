# encoding: UTF-8
require 'nokogiri'
require_relative "../filterable.rb"

module TextTube
  
  # This finds html tags with "markdown='1'" as an attribute, runs markdown over the contents, then removes the markdown attribute, allowing markdown within html blocks
  module InsideBlock
    extend TextTube::Filterable
  
    filter_with :insideblock do |text|
      TextTube::InsideBlock.run text
    end
    
    # @param [String] content
    # @param [Hash] options
    # @option options [Constant] The markdown parser to use. I'm not sure this bit really works for other parsers than RDiscount.    
    def self.run( content, options={})   
      options ||= {} 
      if options[:markdown_parser].nil?
        require 'rdiscount' 
        markdown_parser=RDiscount
      end
      doc = Nokogiri::HTML::fragment(content) 
      
      (doc/"*[@markdown='1']").each do |ele|  
        ele.inner_html = markdown_parser.new(ele.inner_html).to_html
        ele.remove_attribute("markdown")
      end
      
      doc.to_s
    end # run
    
  end # class
end # module
