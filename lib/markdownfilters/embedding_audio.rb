# encoding: UTF-8
module MarkdownFilters

  class EmbeddingAudio
  
    DEFAULTS = {
      loop:      false,
      src_base:  "/streams/",
      preload:   "metadata",
      fallback_text: "Your browser does not support HTML5, update your browser you fool!",
      controls: "controls",
    }
    
    # [audio[link|name]]
    R_link = /             # [audio[url|description]]
      \[audio\[        # opening square brackets
        ([^\|]+)     # link
          \|      # separator
        ([^\[]+)  # description
      \]\]        # closing square brackets
    /x
    
    def self.run(content, options={})
      attributes = DEFAULTS.merge options
           
      content.gsub( R_link ) { |m|
        url,desc = $1,$2
        EmbeddingAudio::render_tag(url,desc,attributes)
      }
    
    end
    
    def self.render_tag(link,desc,attributes)
      fallback_text = attributes.delete(:fallback_text) 
      tag = <<-END
      <div class='audio'>
        <h3>#{desc}</h3>
        <audio src='#{attributes.delete(:src_base)}#{link}' #{attributes.map{|(k,v)| "#{k}='#{v}'" }.join(" ")}>#{fallback_text}</audio>
      </div>
      END
      tag.strip.gsub /\s+/, " "
    end

  end # class
end # module