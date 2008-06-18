class Polls < Application
  before :login_required, :only => %w{ new create }
  before :find_poll, :only => %w{ show }
  before Proc.new{ @nav_active = :polls }
  
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
  
  def new
    @new_poll = Poll.new
    render
  end
  
  def create
  #problem with merge here
    @new_poll = Poll.new(params[:poll].merge(:user_id => session[:user_id]))

    if verify_recaptcha(params[:recaptcha])
      if @new_poll.valid?(:before_poll_creation)
        if @new_poll.save
          @new_forum = Forum.new(:name => @new_poll.question, :poll_id => @new_poll.id)
          @new_forum.save
          @new_topic = Topic.new(:name => "Comments", :forum_id => @new_forum.id,
          :user_id => @new_poll.user_id)
          @new_topic.save
          redirect url(:polls)
        else
          render :new
        end
      end  
    else
      render :new
    end
  end
  
  def show
    render
  end
  
  private
  
  def find_poll
    if (@poll = Poll.first(:id => params[:id])).nil?
      raise NotFound
    end
  end
end