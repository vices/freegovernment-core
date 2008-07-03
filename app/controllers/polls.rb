class Polls < Application
  before :login_required, :only => %w{ new create }
  before :find_poll, :only => %w{ show }
  before Proc.new{ @nav_active = :polls }
  
  #params_accessible :poll => [:]
  
  def index
    case params['filter_by']
      when 'verified_vote_count'
        @filter_by = {:verified_vote_count.gt => 0}
      else 
        @filter_by = nil
    end
    #syntax : :conditions => {:id => 34}
       #       : :conditions => {:verified_vote_count gt 0}
          
    case params['sort_by']
      when 'question'
        @sort_by = :question
      when 'yes_count'
        @sort_by = :yes_count
      when 'no_count'
       pp "made it"
        @sort_by = :no_count
      when 'vote_count'
        Poll.vote_count
        @sort_by = :vote_count
      else
        @sort_by = :created_at
    end
    case params['direction']
      when 'asc'
        @direction = 'asc'
        @order = @sort_by.asc
      else
        @direction = 'desc'
        @order = @sort_by.desc
    end
    #syntax : :conditions => {:id => 34}
       #       : :conditions => {:verified_vote_count gt 0}
      
    @title = 'Latest polls'
    @polls_page = Poll.paginate(:page => params[:page], :per_page => 8, :order => [@order]) #(:order => [@order])
    render
  end

  def by_tag
    @tag = Tag.first(:permalink => params[:tag])
    @title = 'Polls for tag: <span>%s</span>' % @tag.name
    @polls_page = @tag.get_tagged('poll').paginate(:per_page => 8, :page => params[:page]) 
    render :index
  end

  def new
    @new_poll = Poll.new
    render
  end


  def create
  #problem with merge here
    @new_poll = Poll.new(params[:poll].merge(:user_id => session[:user_id]))
    @poll_tags = params[:poll_tags]
    if verify_recaptcha and @new_poll.save
        @new_forum = Forum.new(:name => @new_poll.question, :poll_id => @new_poll.id) #
        @new_forum.save #
        @new_topic = Topic.new(:name => "Comments", :forum_id => @new_forum.id, #
        :user_id => @new_poll.user_id) #
        @new_topic.save #
        Tagging.tag_object(@new_poll, @poll_tags)
        redirect url(:polls) #
    else
      render :new
    end
  end
  
  def show
    @comments = Topic.first(:forum_id => @poll.forum.id, :name => 'Comments').posts.all(:order => [:created_at.desc]).paginate(:page => params[:page], :per_page => 10)
    render
  end
  
  private
  
  def find_poll
    if (@poll = Poll.first(:id => params[:id])).nil?
      raise NotFound #
    end
  end
end