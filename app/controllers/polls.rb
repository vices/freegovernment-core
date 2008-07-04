class Polls < Application
  before :login_required, :only => %w{ new create }
  before :find_poll, :only => %w{ show }
  before Proc.new{ @nav_active = :polls }
  
  #params_accessible :poll => [:]
  

  def index
=begin
    case params['filter_by']
      when 'verified_vote_count'
        @filter_by = {:verified_vote_count.gt => 0}
      else 
        @filter_by = nil
    end
=end
      
    @title = 'Latest polls'
    @polls_page = Poll.paginate({:page => params[:page], :per_page => 8}.merge(search_conditions).merge(order_conditions))
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
        @new_topic = Topic.new(:name => "Comments", :forum_id => @new_forum.id, :user_id => @new_poll.user_id)
        @new_topic.save #
        Tagging.tag_object(@new_poll, @poll_tags)
        redirect url(:polls) #
    else
      render :new
    end
  end
  
  def show
    @comments_topic = Topic.first(:forum_id => @poll.forum.id, :name => 'Comments')
    @comments = @comments_topic.posts.all(:order => [:created_at.desc]).paginate(:page => params[:page], :per_page => 10)
    render
  end
  
  private

  def order_conditions
    params['sort_by'] = '' if params['sort_by'].nil?
    sort_by = case params['sort_by'].downcase
    when 'question'
      :question
    when 'yes_count'
      :yes_count
    when 'no_count'
      :no_count
    when 'created_at'
      :created_at
    else
      :id
    end

    params['direction'] = '' if params['direction'].nil?    
    order = params['direction'].downcase == 'desc' ? sort_by.desc : sort_by.asc
    
    {:order => [order]}
  end

  def search_conditions
    out = {}
    unless params[:search].nil? || params[:search].empty?
      params[:search].each_pair do |col, val|
        out[col.to_sym.like] = "%#{val}%"
      end
    end
    if !out.empty?
      out = {:conditions => out}
    end
    out
  end
  
  def find_poll
    if (@poll = Poll.first(:id => params[:id])).nil?
      raise NotFound #
    end
  end
end
