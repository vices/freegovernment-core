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
      when 'desc'
        @direction = 'desc'
        @order = @sort_by.desc
        
       else
        @direction = 'asc'
        @order = @sort_by.asc
    end
    #syntax : :conditions => {:id => 34}
       #       : :conditions => {:verified_vote_count gt 0}
      
      
      @polls_page = Poll.paginate(:page => params[:page], :per_page => 6) #(:order => [@order])
    #pp @polls_page
    render
  end
  
  def new
    @new_poll = Poll.new
    render
  end


  def create
  #problem with merge here
    @new_poll = Poll.new(params[:poll].merge(:user_id => session[:user_id]))

    if verify_recaptcha and @new_poll.save
        @new_forum = Forum.new(:name => @new_poll.question, :poll_id => @new_poll.id) #
        @new_forum.save #
        @new_topic = Topic.new(:name => "Comments", :forum_id => @new_forum.id, #
        :user_id => @new_poll.user_id) #
        @new_topic.save #
        redirect url(:polls) #
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
      raise NotFound #
    end
  end
end