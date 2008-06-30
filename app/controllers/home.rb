class Home < Application
  before Proc.new{ @nav_active = :home }

  def index
    unless cached?("home_map")
      @map_items = FeedItem.all(:limit => 20)
    end
    render
  end
end
