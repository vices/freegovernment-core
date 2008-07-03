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
    new_posts_count = @topic.posts_count + 1
    @new_post.post_number = new_posts_count
    if @new_post.save
      VideoAttachment.parse_for_videos(@new_post.text).each do |video|
        VideoAttachment.create(:post_id => @new_post.id, :forum_id => @topic.forum_id, :topic_id => @topic.id, :user_id => session[:user_id], :site => video[0], :resource => video[1])
      end
      @topic.posts_count = new_posts_count
      @topic.save
      case params[:from]
        when 'bill'
          redirect url(:bill, :id => @topic.forum.bill_id) + '#comments'
        when 'group'
          redirect url(:group, :id => @topic.forum.group.user.username) + '#comments'
        when 'poll'
          redirect url(:poll, :id => @topic.forum.poll_id) + '#comments'
        else
          redirect post_url(@new_post)
      end
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
