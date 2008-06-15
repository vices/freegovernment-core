class Polls < Application
#  include MerbAuth
  before :login_required, :only => ['create']
  
  def index
    case params['sort_by']
      when 'question'
        @sort_by = :question
      else
        @sort_by = :created_at
    end
    case params['direction']
      when 'desc'
        @direction = 'desc'
        @order = @sort_by.desc
      else
        @direction = 'asc'
        @order = @sort_by.asc
    end
  
    @polls_page = Poll.all(:order => [@order])
    render
  end
  
  def show
    @poll = Poll.first(:id => params[:id])

    if !logged_in? || (@vote = Vote.first(:user_id => session[:user_id], :poll_id => @poll.id)).nil?
      @vote = Vote.new
    end
    
    render
  end
  
  def new
    @new_poll = Poll.new
    @new_forum = Forum.new
    @new_topic = Topic.new
    @new_post = Post.new
    render
  end
  
  def create(poll)
    @new_poll = Poll.new(poll.merge(:user_id => session[:user_id]))

#    @new_post = Post.new
    if verify_recaptcha(params[:recaptcha])
      if @new_poll.valid?(:before_poll_creation) 
        @new_poll.save
        @new_forum = Forum.new(:name => @new_poll.question, :poll_id => @new_poll.id)
        @new_forum.save
        @new_topic = Topic.new(:name => "Comments", :forum_id => @new_forum.id,
        :user_id => @new_poll.user_id)
        @new_topic.save
#        @new_post.save
        redirect url(:polls)
      else
        render :new
      end
    else
      render :new
    end
  end
  
  def edit
  
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
end