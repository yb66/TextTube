# encoding: UTF-8
module MarkdownFilters

  class EmbeddingAudio < Before
  
    DEFAULTS = {
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
      options ||= {}
      attributes = DEFAULTS.merge options
           
      content.gsub( R_link ) { |m|
        url,desc = $1,$2
        EmbeddingAudio::render_tag(url,desc,attributes)
      }
    end


    def self.render_tag(link,desc,attributes)
      fallback_text = attributes.delete(:fallback_text)
      src_base = attributes.delete(:src_base)
      make_inner = ->(lnk){%Q!<source src='#{src_base}#{lnk}' type='audio/#{File.extname(lnk)[1..-1]}' />!}
      inner = make_inner.( link )
      inner += make_inner.( link.sub(/m4a$/, "ogg") ) if File.extname(link) == ".m4a"
      %Q!<div class='audio'><h3>#{desc}</h3><audio #{attributes.map{|(k,v)| "#{k}='#{v}'" }.join(" ")}>#{inner}#{fallback_text}</audio></div>!.strip.gsub /\s+/, " "
    end

  end # class
end # module