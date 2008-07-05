class Home < Application
  before Proc.new{ @nav_active = :home }
  before :login_required, :only => 'start'
  before :get_blog

  def index
    if logged_in?
      redirect url(:start)
    else
      unless cached?("home_map")
        @map_items = FeedItem.all(:limit => 20, :links => [:user], :conditions => ["address_lat IS NOT NULL"], :order => [:id.desc])
      end
      render
    end
  end

  def start
    unless cached?("home_map")
      @map_items = FeedItem.all(:limit => 20, :links => [:user], :conditions => ["address_lat IS NOT NULL"], :order => [:id.desc])
    end
    related_ids = []
    if @current_user.group_id.nil?
      @current_user.person.contact_relationships.each{ |c| related_ids << c.contact.user_id }
      @current_user.person.group_relationships.each{ |g| related_ids << g.group.user_id }
    else
      @current_user.group.group_relationships.each{ |g| related_ids << g.person.user_id }
    end
    unless related_ids.empty?
      @feed_items = FeedItem.all(:limit => 15, :user_id.in => related_ids, :order => [:id.desc])
    end
    unless @current_user.is_adviser
      adviser_ids = @current_user.person.advisers.collect{ |a| a.id }
      if !adviser_ids.nil? && !adviser_ids.empty?
        @adv_updates = FeedItem.all(:limit => 15, :user_id.in => adviser_ids, :what => 'vote', :order => [:id.desc])
      end
    end
    render
  end

  private

  def get_blog
    begin
      unless cached?("home_blog")
        @rss = FeedNormalizer::FeedNormalizer.parse open('http://feeds.feedburner.com/freegovernment')
      end
    rescue
    end
  end
end
