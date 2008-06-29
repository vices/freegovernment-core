class VideoAttachment
  include DataMapper::Resource
  include DataMapper::Validate
  
  VIDEO_REGEXES = {
    :youtube => /youtube\.com(?:\/watch|)\?v=([a-z0-9_-]+)/i,
    :myspace => /(?:myspacetv\.com|vids\.myspace\.com)\/index\.cfm\?fuseaction=vids\.individual&videoid=([0-9]+)/i
  }
  
  VIDEO_EMBEDS = {
    :youtube => '<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/$$RESOURCE$$=en"></param><embed src="http://www.youtube.com/v/$$RESOURCE$$&hl=en" type="application/x-shockwave-flash" width="425" height="344"></embed></object>',
    :myspace => '<object width="425" height="360"><param name="movie" value="http://mediaservices.myspace.com/services/media/embed.aspx/m=$$RESOURCE$$,t=1,mt=video"/><param name="allowFullScreen" value="true"/><embed src="http://mediaservices.myspace.com/services/media/embed.aspx/m=$$RESOURCE$$,t=1,mt=video" allowFullScreen="true" type="application/x-shockwave-flash" width="425" height="360"></embed></object>'
  }

  
  property :id, Integer, :serial => true
  property :title, String
  property :post_id, Integer, :nullable => false
  property :forum_id, Integer, :nullable => false
  property :topic_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :site, String, :nullable => false
  property :resource, String, :length => 300, :nullable => false
  
  belongs_to :post
  
  def to_embed
    VIDEO_EMBEDS[self.type.to_sym].gsub('$$RESOURCE$$', self.resource)
  end
  
  before :save do
    if self.site == 'youtube'
      feed = REXML::Document.new open('http://gdata.youtube.com/feeds/api/videos/' + self.resource)
      p self.title = feed.root.get_elements('title')[0].get_text
    end
  end
  
  class << self
    def parse_for_videos(text)
      videos = []
      VIDEO_REGEXES.each_pair do |site, re|
        text.scan(re).each do |match|
          videos << [site.to_s, match]
        end
      end
      videos
    end
  end
end
