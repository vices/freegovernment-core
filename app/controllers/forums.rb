class Forums < Application
  before Proc.new{ @nav_active = :forums }
  before :find_forum, :only => 'show'
  params_accessible [
    {:forum => []}
  ]
  
  # Lists forums (paginated?)
  def index
    @general_forums = Forum.all(:poll_id => nil, :group_id => nil)
    @group_forums = Forum.paginate(:page => params[:group_page], :per_page => 6, :conditions => {:group_id.not => nil})
    @poll_forums = Forum.paginate(:page => params[:poll_page], :per_page => 6, :conditions => {:poll_id.not => nil})
    render
  end
  
  # Shows forum / Lists paginated topics of forum
  def show
    @topics_page = Topic.paginate(:page => params[:page], :per_page => 10, :conditions => {:forum_id => @forum.id})
    render
  end
  
  private
  
  def find_forum
    if(@forum = Forum.first(:id => params[:id].to_i)).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

end