# encoding: UTF-8
module MarkdownFilters

  require 'hpricot' 
  require 'coderay'

  # a filter for Coderay
  class Coderay

    def self.run(content, options={})
      options = {lang: :ruby } if options.nil? || options.empty? 
      doc = Hpricot(content) 

      code_blocks = (doc/"pre/code").map do |code_block| 
        #un-escape as Coderay will escape it again
        inner_html = code_block.inner_html
        
        # following the convention of Rack::Codehighlighter
        if inner_html.start_with?("::::") 
          lines = inner_html.split("\n")
          options[:lang] = lines.shift.match(%r{::::(\w+)})[1].to_sym
          inner_html = lines.join("\n")
        end

        if (options[:lang] == :skip) || (! options.has_key? :lang )
          code_block.inner_html = inner_html
        else
          code = Coderay.codify(Coderay.html_unescape(inner_html), options[:lang]) 
          code_block.inner_html = code 
          code_block["class"] = "Coderay"    
        end      
      end#block

      doc.to_s
    end#def

    def self.html_unescape(a_string) 
      a_string.gsub('&amp;', '&').gsub('&lt;', '<').gsub('&gt;', 
      '>').gsub('&quot;', '"') 
    end#def

    def self.codify(str, lang) 
      CodeRay.scan(str, lang).html
    end#def

  end#class 


end#module