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
    @posts_page = @topic.posts.paginate(:page => params[:page], :per_page => 10)
    @videos = VideoAttachment.all(:topic_id => @topic.id)
    render
  end

  def new
    @new_topic = Topic.new
    @new_post = Post.new
    render
  end

  def create
    if @new_topic.save
      @forum.topics_count = @forum.topics_count + 1
      @forum.save
      @new_post.topic_id = @new_topic.id
      @new_post.post_number = 1
      if @new_post.save
        @forum.posts_count = @forum.posts_count + 1
        @forum.save
        @new_topic.posts_count = 1
        @new_topic.save
        VideoAttachment.parse_for_videos(@new_post.text).each do |video|
          VideoAttachment.create(:post_id => @new_post.id, :forum_id => @new_topic.forum_id, :topic_id => @new_topic.id, :user_id => session[:user_id], :site => video[0], :resource => video[1])
        end
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