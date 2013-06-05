# encoding: UTF-8
module MarkdownFilters
  
  # @author Iain Barnett
  # A class to take links in the format `[[link|description]]` and give them a number reference, then output them in markdown format. Note: this is not the same as reference links in markdown, this is more akin to the way books will refer to references or footnotes with a number.
  #P.S. I don't like to make functions private, we're all adults, so to use this call Link_reffing#run, #format_links is for internal use.
  class LinkReffing < Before
    
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
    
    # a lambda function to transform a link and a number into a markdown reference link
    # @param [String] lnk The url.
    # @param [String] num The reference number.
    Markdowner = ->(lnk, num){ %Q![#{lnk}](##{num} "Jump to reference")! }

    HTMLer = ->(lnk, num){ %Q!<a href="#{lnk}" title="Jump to reference">#{num}</a>!  }
    
    # Takes markdown content with ref links and turns it into 100% markdown.
    # @param [String] content The markdown content with links to ref.
    # @option options [#to_s] :format The format of the link you want added. The options are :html, :markdown. The default is :markdown
    # @option options [#to_s] :type The kind of link you want added. The options are :reference, :normal, :none. The default is :reference
    # @option options [String,nil] :div_id ID of the div to wrap reference links in. Defaults to "reflinks". Set to nil or false for no div.
    # @return [String] The string formatted as markdown e.g. `[http://cheat.errtheblog.com/s/yard/more/and/m...](http://cheat.errtheblog.com/s/yard/more/and/more/and/more/ "http://cheat.errtheblog.com/s/yard/more/and/more/and/more/")`
    def self.run(content, options={})
      return content if content.blank?
      options ||= {}
      type = options.fetch :type, :reference
      format = case options.fetch( :format, :markdown )
        when :html then HTMLer
        when :markdown then Markdowner
        else Markdowner
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
      
      content.gsub! Pattern do |md|  #block to pass to gsub
        has_reflinks = true
        mags = cur.divmod(10) #get magnitude of number
        ref_tag = mags.first >= 1 ? 
                    UNITS[mags.first] :
                    '' #sort out tens

        ref_tag += UNITS[mags.last] #units
        
        retval = format.(ref_tag,cur)
        cur = cur + 1 #increase current number
        links << [$1, $2, cur] # add to the words list
        retval
      end

      if !links.empty?
        if div_id
          "#{content}\n#{LinkReffing.divit( div_id ) { format_links(links) }}"
        else
          "#{content}\n#{format_links(links)}"
        end
      else
        content
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