class Forums < Application
  before Proc.new{ @nav_active = :forums }
  
  def index
    @general_forums = Forum.all(:poll_id => nil, :group_id => nil)
    #@group_forums = Forum.all(:group_id.not => nil)
    #@poll_forums = Forum.all(:poll_id.not => nil)
    render
  end

end