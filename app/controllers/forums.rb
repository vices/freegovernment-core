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
    @poll_forums = Forum.paginate(:page => params[:poll_page], :per_page => 6, :conditions => {:poll_id.not => nil, :bill_id => nil})
    @bill_forums = Forum.paginate(:page => params[:poll_page], :per_page => 6, :conditions => {:bill_id.not => nil})
    render
  end
  
  def group_index
    @what = 'Group'
    @route = :group_index
    @forums_page = Forum.paginate(:page => params[:page], :per_page => 20, :conditions => {:group_id.not => nil})
    render :template => 'forums/index_specified.html'
  end

  def poll_index
    @what = 'Poll-Related'
    @route = :poll_index
    @forums_page = Forum.paginate(:page => params[:page], :per_page => 20, :conditions => {:poll_id.not => nil, :bill_id => nil})
    render :template => 'forums/index_specified.html'
  end

  def bill_index
    @what = 'Bill-Related'
    @route = :bill_index
    @forums_page = Forum.paginate(:page => params[:page], :per_page => 20, :conditions => {:bill_id.not => nil})
    render :template => 'forums/index_specified.html'
  end

  # Shows forum / Lists paginated topics of forum
  def show
    @topics_page = Topic.paginate(:page => params[:page], :per_page => 20, :conditions => {:forum_id => @forum.id})
    render
  end
  
  private
  
  def find_forum
    if(@forum = Forum.first(:id => params[:id].to_i)).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

end
