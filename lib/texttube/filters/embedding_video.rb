# encoding: UTF-8
require_relative "../filterable.rb"

module TextTube

  # Embed video via [embed_SIZE[url|description]]
  module EmbeddingVideo
    extend TextTube::Filterable
  
    filter_with :embeddingvideo do |text|
      TextTube::EmbeddingVideo.run text
    end

    # List of available sites.
    SITES = {
      #     "video.google".to_sym => ['http://www.video.google.com/',->(w,h,url){ %Q!! }],
      #     :brightcove => ['http://www.brightcove.com/',->(w,h,url){ %Q!! }],
      #     :photobucket => ['http://www.photobucket.com/',->(w,h,url){ %Q!! }],
      :youtube => {
        name: 'http://www.youtube.com/',
        html: ->(w,h,url){ %Q!<iframe title="YouTube video player" class="youtube-player" type="text/html" width="#{w}" height="#{h}" src="#{url}" frameborder="0"></iframe>!.strip},
        url_morph: ->(orig){ orig.sub( %r{watch\?v=}, 'embed/') }
      },
      #     :dailymotion => ['http://dailymotion.com/',->(w,h,url){ %Q!! }],
      #     :ifilm => ['http://ifilm.com/',->(w,h,url){ %Q!! }],
      #     :break => ['http://break.com/',->(w,h,url){ %Q!! }],
      #     :blip => ['http://blip.tv/',->(w,h,url){ %Q!! }],
      #     :grindtv => ['http://www.grindtv.com/',->(w,h,url){ %Q!! }],
      #     :metacafe => ['http://metacafe.com/',->(w,h,url){ %Q!! }],
      #     :myspace => ['http://vids.myspace.com/',->(w,h,url){ %Q!! }],
      #     :vimeo => ['http://vimeo.com/',->(w,h,url){ %Q!! }],
      #     :buzznet => ['http://buzznet.com/',->(w,h,url){ %Q!! }],
      #     :liveleak => ['http://www.liveleak.com/',->(w,h,url){ %Q!! }],
      #     :stupidvideos => ['http://stupidvideos.com/',->(w,h,url){ %Q!! }],
      #     :flixya => ['http://www.flixya.com/',->(w,h,url){ %Q!! }],
      #     :gofish => ['http://gofish.com/',->(w,h,url){ %Q!! }],
      #     :kewego => ['http://kewego.com/',->(w,h,url){ %Q!! }],
      #     :lulu => ['http://lulu.tv/',->(w,h,url){ %Q!! }],
      #     :pandora => ['http://pandora.tv/',->(w,h,url){ %Q!! }],
      #     :viddler => ['http://www.viddler.com/',->(w,h,url){ %Q!! }],
      #     :myheavy => ['http://myheavy.com/',->(w,h,url){ %Q!! }],
      #     :putfile => ['http://putfile.com/',->(w,h,url){ %Q!! }],
      #     :stupidvideos => ['http://stupidvideos.com/',->(w,h,url){ %Q!! }],
      #     :vmix => ['http://vmix.com/',->(w,h,url){ %Q!! }],
      #     :zippyvideos => ['http://zippyvideos.com/',->(w,h,url){ %Q!! }],
      #     :castpost => ['http://castpost.com/',->(w,h,url){ %Q!! }],
      #     :dotv => ['http://dotv.com/',->(w,h,url){ %Q!! }],
      #     :famster => ['http://famster.com/',->(w,h,url){ %Q!! }],
      #     :gawkk => ['http://gawkk.com/',->(w,h,url){ %Q!! }],
      #     :tubetorial => ['http://tubetorial.com/',->(w,h,url){ %Q!! }],
      #     :MeraVideo => ['http://MeraVideo.com/',->(w,h,url){ %Q!! }],
      #     :Porkolt => ['http://Porkolt.com/',->(w,h,url){ %Q!! }],
      #     :VideoWebTown => ['http://VideoWebTown.com/',->(w,h,url){ %Q!! }],
      #     :Vidmax => ['http://Vidmax.com/',->(w,h,url){ %Q!! }],
      #     :clipmoon => ['http://www.clipmoon.com/',->(w,h,url){ %Q!! }],
      #     :motorsportmad => ['http://motorsportmad.com/',->(w,h,url){ %Q!! }],
      #     :thatshow => ['http://www.thatshow.com/',->(w,h,url){ %Q!! }],
      #     :clipchef => ['http://clipchef.com/',->(w,h,url){ %Q!! }],
    }

    # Some standard player sizes.
    SIZES = {
      small:    [560,345],
      medium:   [640,390],
      large:    [853,510],
      largest:  [1280,750] }



    #     r_url = %r{
    #               http(?:s)?\://          #http https ://
    #               (?:(?:www|vids)\.)?     # www. vids.
    #               (.+?)                   # domain name (hopefully)
    #               \.(?:com|tv)            # .com .tv
    #               /?                      # optional trailing slash
    #               }x

    # Pattern for deconstructing [embed_SIZE[url|description]]
    R_link = /             # [embed_SIZE[url|description]]
    \[embed\_?([a-z]+)?\[        # opening square brackets
      (\S+)     # link
      \|      # separator
      ([^\[]+)  # description
      \]\]        # closing square brackets
      /x


    # @param [String] content
    # @param [Hash] options
    # @return [String]
    def self.run(content, options={})
      options ||= {}
      content.gsub( R_link ) { |m|
        size,url,desc = $1,$2,$3

        unless size.nil?
          res = SIZES[size.to_sym] || SIZES[:medium] #resolution
        else
          res = SIZES[:medium]
        end

        #"res: #{res.inspect} size: #{size}, url:#{url}, desc:#{desc}"

        emb_url = SITES[:youtube][:url_morph].(url)
        SITES[:youtube][:html].(res.first, res.last, emb_url )
      }

    end

  end # class
end # module