class Topics < Application
  before Proc.new{ @nav_active = :forums }
  before :login_required, :only => %w{ new create destroy }
  before :find_topic, :only => %w{ show }
  before :find_forum, :only => %w{ new create }
  before :check_create_permissions, :only => 'create'
  #params_accessible [
  #  {:topic => [:name, :forum_id], :post => [:text]}  
  #]

  # Shows topic / Lists paginated posts
  def show
    @posts_page = @topic.posts
    render
  end

  def new
    @new_topic = Topic.new
    @new_post = Post.new
    render
  end

  def create
    p 'here'
    if @new_topic.save
      @new_post.topic_id = @new_topic.id
      if @new_post.save
        redirect url(:forum, :id => @new_topic.forum_id)
      else
        render :new
      end
    else
      render :new
    end
  end
  
  def destroy
  
  end
  
  private
  
  def find_topic
    if(@topic = Topic.first(:id => params[:id])).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
  
  def find_forum
    unless params[:topic].nil?
      forum_id = params[:topic][:forum_id]
    else
      forum_id = params[:forum_id]
    end
    p 'hi'
    p forum_id
    if(@forum = Forum.first(:id => forum_id)).nil?
    pp "hey"
      raise Merb::ControllerExceptions::NotFound
    end
  end

  def check_create_permissions
    @new_topic = Topic.new(params[:topic].merge(:user_id => session[:user_id]))
    @new_post = Post.new(params[:post].merge(:user_id => session[:user_id]))
  end

end