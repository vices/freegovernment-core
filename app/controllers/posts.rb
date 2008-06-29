class Posts < Application
  before Proc.new{ @nav_active = :forums }
  before :login_required, :only => %w{ new create destroy }
  before :find_topic, :only => %w{ new create }
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
      VideoAttachment.parse_for_videos(@new_post.text).each do |video|
        VideoAttachment.create(:post_id => @new_post.id, :forum_id => @topic.forum_id, :topic_id => @topic.id, :user_id => session[:user_id], :type => video[0], :resource => video[1])
      end
      redirect url(:topic, :id => @topic.id)
    else
      render :new
    end
  end
  
  def destroy
  
  end
  
  private
  
  def find_topic
    unless params[:post].nil?
      topic_id = params[:post][:topic_id]
    else
      topic_id = params[:topic_id]
    end
    if(@topic = Topic.first(:id => topic_id)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
  
  def check_create_permissions
    @new_post = Post.new(params[:post].merge(:user_id => session[:user_id]))
  end

end
