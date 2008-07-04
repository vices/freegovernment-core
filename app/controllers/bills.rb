class Bills < Application
  before Proc.new{ @nav_active = :bills }
  before :login_required, :only => %w{ new create }
  before :find_bill, :only => %w{ show }

  def index
    @pagination_params = {}
    if search_conditions[:conditions].nil?
      @title = 'Latest bills'
    else
      @title = 'Pills for query: <span>%s</span>' % params[:search][:question]
      @pagination_params = { 'search[question]' => params[:search][:question] }
    end
    @bills_page = Bill.paginate({:page => params[:page], :per_page => 8}.merge(search_conditions).merge(order_conditions))
    render
  end

  def by_tag
    @tag = Tag.first(:permalink => params[:tag])
    @title = 'Bills for tag: <span>%s</span>' % @tag.name
    @bills_page = @tag.get_tagged('bill').paginate(:per_page => 8, :page => params[:page]) 
    render :index
  end

  def new
    @new_bill = Bill.new
    render
  end

  def create
    @new_bill = Bill.new(params[:bill].merge(:user_id => session[:user_id]))
    @bill_tags = params[:bill_tags]
    if @new_bill.save
      poll = Poll.create(:question => "Do you support FG Bill ##{@new_bill.id}?", :description => @new_bill.title, :user_id => session[:user_id], :bill_id => @new_bill.id)
      forum = Forum.create(:name => "FG Bill ##{@new_bill.id} - #{@new_bill.title}".ellipsis(140), :bill_id => @new_bill.id, :poll_id => poll.id, :topics_count => 1)
      poll.forum_id = forum.id
      poll.save
      Topic.create(:forum_id => forum.id, :name => 'Comments', :user_id => session[:user_id])
      @new_bill.update_attributes(:forum_id => forum.id, :poll_id => poll.id)
      BillSection.section_text(@new_bill)
      Tagging.tag_object(@new_bill, @bill_tags)
      Tagging.tag_object(poll, @bill_tags)
      redirect url(:bill, :id => @new_bill.id)
    else
      render :new
    end
  end

  def show
    render
  end

  private

  def order_conditions
    params['sort_by'] = '' if params['sort_by'].nil?
    sort_by = case params['sort_by'].downcase
    when 'title'
      :title
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

  def find_bill
    if(@bill = Bill.first(:id => params[:id])).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
end
