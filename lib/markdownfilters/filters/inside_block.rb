# encoding: UTF-8
module MarkdownFilters
  
  # This finds html tags with "markdown='1'" as an attribute, runs markdown over the contents, then removes the markdown attribute, allowing markdown within html blocks
  class InsideBlock < After
    require 'hpricot'
    
    
    def self.run( content, options={})   
      options ||= {} 
      if options[:markdown_parser].nil?
        require 'rdiscount' 
        markdown_parser=RDiscount
      end
      doc = Hpricot(content) 
      
      (doc/"*[@markdown='1']").each do |ele|  
        ele.inner_html = markdown_parser.new(ele.inner_html).to_html
        ele.remove_attribute("markdown")
      end
      
      doc.to_s
    end # run
    
  end # class
end # module
