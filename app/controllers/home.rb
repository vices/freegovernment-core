class Home < Application
  before Proc.new{ @nav_active = :home }
  before :login_required, :only => 'start'

  def index
    unless cached?("home_map")
      @map_items = FeedItem.all(:limit => 20)
    end
    render
  end

  def start
    if !@current_user.person_id.nil?
      @new_cr_count = ContactRelationship.count(:contact_id => @current_user.person_id, :is_accepted => 0)
    else
      @new_gr_count = GroupRelationship.count(:group_id => @current_user.group_id, :is_accepted => 0)
    end
    render
  end

end
