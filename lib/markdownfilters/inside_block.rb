# encoding: UTF-8
module MarkdownFilters
  class InsideBlock
    require 'hpricot'
    
    def self.run( content, markdown_parser )    
      doc = Hpricot(content) 
      
      (doc/"*[@markdown='1']").each do |ele|  
        ele.inner_html = markdown_parser.new(ele.inner_html).to_html
        ele.remove_attribute("markdown")
      end
      
      doc.to_s
    end # run
    
  end # class
end # module
