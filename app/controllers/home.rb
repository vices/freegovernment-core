class Home < Application
  before Proc.new{ @nav_active = :home }

  def index
    @map_items = FeedItem.all(:limit => 20)
    render
  end
end
