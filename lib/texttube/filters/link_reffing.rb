# encoding: UTF-8
require_relative "../filterable.rb"

module TextTube
  
  # @author Iain Barnett
  # A class to take links in the format `[[link|description]]` and give them a number reference, then output them in markdown format. Note: this is not the same as reference links in markdown, this is more akin to the way books will refer to references or footnotes with a number.
  #P.S. I don't like to make functions private, we're all adults, so to use this call Link_reffing#run, #format_links is for internal use.
  module LinkReffing
    extend Filterable
    
    filter_with :linkreffing do |text, options|
      TextTube::LinkReffing.run text, options
    end
    
    # These are the html codes for superscript 0 - 9
    UNITS = ['&#8304;', '&sup1;', '&sup2;', '&sup3;', '&#8308;', '&#8309;', '&#8310;', '&#8311;', '&#8312;', '&#8313;'] #unicode superscript numbers

    # Matches [[link|description]]
    Pattern = /              
          \[\[                      # opening square brackets
            (?<link>\S+)
              \s*\|\s*              # separator
            (?<description>[^\[]+)
          \]\]                      # closing square brackets
        /x
    
    # a lambda function to transform a link and a number into a markdown reference link.
    # @param [String] lnk The url.
    # @param [String] num The reference number.
    Reffer = ->(lnk, num){ %Q![#{lnk}](##{num} "Jump to reference")!}

    # A lambda to transform a link and a number to a HTML reference link.
    RefHTMLer = ->(lnk, num){ %Q!<a href="##{num}" title="Jump to reference">#{lnk}</a>!  }

    # A lambda to transform a href and a description into an HTML link.
    HTMLer = ->(lnk, desc){ %Q! <a href="#{lnk}">#{desc}</a>!  }

    # A lambda to transform a link and a description into an inline Markdown link.
    Markdowner = ->(lnk, desc){ %Q! [#{desc}](#{lnk})! }

#     Noner = ->(_,_) { "" } # this isn't needed but will sit here as a reminder.


    # Takes markdown content with ref links and turns it into 100% markdown.
    # @param [String] content The markdown content with links to ref.
    # @option options [#to_s] :format The format of the link you want added. The options are :html, :markdown. The default is :markdown
    # @option options [#to_s] :kind The kind of link you want added. The options are :reference, :inline, :none. The default is :reference
    # @option options [String,nil] :div_id ID of the div to wrap reference links in. Defaults to "reflinks". Set to nil or false for no div.
    # @return [String] The string formatted as markdown e.g. `[http://cheat.errtheblog.com/s/yard/more/and/m...](http://cheat.errtheblog.com/s/yard/more/and/more/and/more/ "http://cheat.errtheblog.com/s/yard/more/and/more/and/more/")`
    def self.run(content, options={})
      return content if content.blank?
      text = content.dup
      options ||= {}
      kind = options.fetch :kind, :reference
      format = options.fetch( :format, :markdown )
      formatter = if kind == :inline
                    if format == :html
                      HTMLer
                    else
                      Markdowner
                    end
                  elsif kind == :none
                    nil # none is needed
                  else # kind == :reference
                    if format == :html
                      RefHTMLer
                    else
                      Reffer
                    end
                  end
      
      div_id =  options.has_key?(:div_id) ? 
                  options[:div_id] :
                  :reflinks

      cur = 0 #current number

      # if there are no reflinks found
      # this will remain false
      # and `divit` won't be run.
      has_reflinks = false

      links = [] #to store the matches
      
      text.gsub! Pattern do |md|  #block to pass to gsub
        has_reflinks = true
        if kind == :inline
          formatter.($1,$2)
        elsif kind == :none
          ""
        else # kind == :reference
          mags = cur.divmod(10) #get magnitude of number
          ref_tag = mags.first >= 1 ? 
                      UNITS[mags.first] :
                      '' #sort out tens
  
          ref_tag += UNITS[mags.last] #units
          retval = formatter.(ref_tag,cur)
                     
          links << [$1, $2, cur] # add to the words list
          cur += 1 #increase current number
          retval
        end
      end

      if !links.empty?
        if has_reflinks && div_id
          "#{text}\n#{LinkReffing.divit( div_id ) { format_links(links) }}"
        else
          "#{text}\n#{format_links(links)}"
        end
      else
        text
      end
    end


    # This func outputs the link as valid markdown.
    # @param [Array<String,String,Integer>] links A list of 2-length arrays containing the url and the description and the reference number.
    def self.format_links( links )
      links.map{ |(link, description, cur)|
        display_link = link.length >= 45 ? 
                          link[0,45] + "..." : 
                          link
        %Q!\n<a name="#{cur}"></a>#{LeftSq}#{cur}#{RightSq} [#{display_link}](#{link} "#{link}") #{description}\n\n!
      }.join
    end


    # Wraps things in a div. If no id given, no div.
    # @param [#to_s] id The ID attribute for the div.
    def self.divit( id )
      "<div markdown='1' id='#{id}'>#{ yield }</div>"
    end

    # HTML code for [
    LeftSq = "&#91;"
    # HTML code for ]
    RightSq = "&#93;"
    
  end#class
 
end#module