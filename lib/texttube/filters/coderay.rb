# encoding: UTF-8
module TextTube

  require 'nokogiri'
  require_relative "../../ext/blank.rb"
  require 'coderay'
  require_relative "../filterable.rb"

  # a filter for Coderay
  module Coderay
    extend Filterable

    filter_with :coderay do |text|
      TextTube::Coderay.run text
    end


    # @param [String] content
    # @param [Hash] options
    # @return [String]
    def self.run(content, options={})
      options = {lang: :ruby } if options.blank? 
      doc = Nokogiri::HTML::fragment(content) 

      code_blocks = doc.xpath("pre/code").map do |code_block| 
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
          code_block["class"] = "CodeRay"    
        end      
      end#block

      doc.to_s
    end#def

    # @private
    # Unescape the HTML as the Coderay scanner won't work otherwise.
    def self.html_unescape(a_string) 
      a_string.gsub('&amp;', '&').gsub('&lt;', '<').gsub('&gt;', 
      '>').gsub('&quot;', '"') 
    end#def

    # Run the Coderay scanner.
    # @private
    # @param [String] str
    # @param [String] lang
    # @example
    #   self.class.codify "x = 2", "ruby"
    def self.codify(str, lang) 
      CodeRay.scan(str, lang).html
    end#def

  end#class 


end#module