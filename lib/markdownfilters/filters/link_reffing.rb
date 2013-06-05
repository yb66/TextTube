# encoding: UTF-8
module MarkdownFilters
  
  # @author Iain Barnett
  # A class to take links in the format `[[link|description]]` and give them a number reference, then output them in markdown format. Note: this is not the same as reference links in markdown, this is more akin to the way books will refer to references or footnotes with a number.
  #P.S. I don't like to make functions private, we're all adults, so to use this call Link_reffing#run, #format_links is for internal use.
  class LinkReffing < Before
    
    # These are the html codes for superscript 0 - 9
    UNITS = ['&#8304;', '&sup1;', '&sup2;', '&sup3;', '&#8308;', '&#8309;', '&#8310;', '&#8311;', '&#8312;', '&#8313;'] #unicode superscript numbers
    
    # a lambda function to transform a link and a number into a markdown reference link
    # @param [String] lnk The url.
    # @param [String] num The reference number.
    Markdowner = ->(lnk, num){ %Q![#{lnk}](##{num} "Jump to reference")! }
    
    # Takes markdown content with ref links and turns it into 100% markdown.
    # @param [String] content The markdown content with links to ref.
    def self.run(content, options={})
      options ||= {}
      cur = 0 #current number
      links = [ ] #to store the matches
      
      blk = ->(m) do  #block to pass to gsub
        links << [$1, $2] # add to the words list
        mags = cur.divmod(10) #get magnitude of number
        ref_tag = mags.first >= 1 ? UNITS[mags.first] : '' #sort out tens
        ref_tag += UNITS[mags.last] #units
        
        
        format = options[:format].nil? ? Markdowner : options[:format] # markdown is the default format
        retval = format.(ref_tag,cur)
        cur = cur + 1 #increase current number
    
        retval
      end
      
      r = /              # [[link|description]]
            \[\[         # opening square brackets
              (\S+)      # link
                \s*\|\s* # separator
              ([^\[]+)   # description
            \]\]         # closing square brackets
          /x 
      
      if r.match content
        replacement = content.gsub( r, &blk ) + "\n"
        replacement + LinkReffing.format_links(links) unless links.empty?
      else
        content
      end
      
    end
      
    # This func outputs the link as valid markdown.
    # @param [Hash] options Options hash.
    # @param [Array<String,String>] links A list of 2-length arrays containing the url and the description.
    # @option options [true,false] :top_html_rule Whether to put a horizontal rule across the top of the link.
    # @option options [true,false] :bottom_html_rule Whether to put a horizontal rule across the bottom of the link.
    # @option options [String,nil] :div Name of the div to wrap reference links in. Defaults to "reflinks". Set to nil for no div.
    # @return [String] The string formatted as markdown e.g. `[http://cheat.errtheblog.com/s/yard/more/and/m...](http://cheat.errtheblog.com/s/yard/more/and/more/and/more/ "http://cheat.errtheblog.com/s/yard/more/and/more/and/more/")`
    def self.format_links( links, options={div: "reflinks"} )
      text = ""
      cur = 0
      links.each do |lnk|
        display_link = lnk.first.length >= 45 ? 
                          lnk.first[0,45] + "..." : 
                          lnk.first
        text += %Q!\n<a name="#{cur}"></a>#{LeftSq}#{cur}#{RightSq} [#{display_link}](#{lnk.first} "#{lnk.first}") #{lnk.last}\n\n!
        cur += 1
      end
      LinkReffing.divit( options[:div] ) do
        text
      end
    end
      
    # wraps things in a div. If no id given, no div.
    def self.divit( id=nil )
      if id.nil?
        yield 
      else
        "<div markdown='1' id='#{id}'>" +
          yield +
        "</div>"
      end
    end

    # HTML code for [
    LeftSq = "&#91;"
    # HTML code for ]
    RightSq = "&#93;"
    
  end#class
 
end#module