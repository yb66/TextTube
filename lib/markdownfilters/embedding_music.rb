# encoding: UTF-8
module MarkdownFilters

  class EmbeddingMusic
  
    def run(content, params={})
    
      html = ->(link,desc){ <<END
<div class="music">
  <h3>#{desc}</h3>
  <audio src="/files/#{link}" controls="controls">
  Your browser does not support the audio element.
  </audio>
</div>
END
      }
    
      # [music[link|name]]
      r_link = /             # [music[url|description]]
        \[music\[        # opening square brackets
          ([^\|]+)     # link
            \|      # separator
          ([^\[]+)  # description
        \]\]        # closing square brackets
      /x
    
      content.gsub( r_link ) { |m|
        url,desc = $1,$2
        html.(url,desc)
      }
    
    end

  end # class
end # module