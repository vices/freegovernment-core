class Posts < Application
  before Proc.new{ @nav_active = :forums }
  before :login_required, :only => %w{ new create destroy }
  before :find_topic, :only => %{ new create }
  before :check_create_permissions, :only => %w{ create }
  
  # Shows individual post
  def show
    render
  end

  def new
    @new_post = Post.new
    render
  end

  def create
    if @new_post.save
      redirect url(:topic, :id => @topic.id)
    else
      render :new
    end
  end
  
  def destroy
  
  end
  
  private
  
  def find_topic
    if(@topic = Topic.first(:forum_id => params[:post][:forum_id], :topic_id => params[:post][:topic_id])).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def check_create_permissions
    @new_post = params[:post]
  end

end