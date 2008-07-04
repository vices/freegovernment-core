class Home < Application
  before Proc.new{ @nav_active = :home }
  before :login_required, :only => 'start'

  def index
    unless cached?("home_map")
      @map_items = FeedItem.all(:limit => 20, :links => [:user], :conditions => ["address_lat IS NOT NULL"])
    end
    render
  end

  def start
    unless cached?("home_map")
      @map_items = FeedItem.all(:limit => 20, :links => [:user], :conditions => ["address_lat IS NOT NULL"])
    end
    render
  end

end
