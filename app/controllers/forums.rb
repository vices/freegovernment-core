class Forums < Application
  before Proc.new{ @nav_active = :forums }
  before :find_forum, :only => 'show'
  
  # Lists forums (paginated?)
  def index
    @general_forums = Forum.all(:poll_id => nil, :group_id => nil)
    #@group_forums = Forum.all(:group_id.not => nil)
    #@poll_forums = Forum.all(:poll_id.not => nil)
    render
  end
  
  # Shows forum / Lists paginated topics of forum
  def show
    @topics_page = Topic.all(:forum_id => @forum.id)
    render
  end
  
  private
  
  def find_forum
    if(@forum = Forum.first(:id => params[:id].to_i)).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

end