class Bills < Application
  before Proc.new{ @nav_active = :bills }
  before :login_required, :only => %w{ new create }
  before :find_bill, :only => %w{ show }

  def index
    @bills_page = Bill.paginate(:per_page => 8, :page => params[:page], :order => [:created_at.desc])
    render
  end

  def by_tag
    @tag = Tag.first(:permalink => params[:tag])
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
      Tagging.tag_object(@new_bill, @bill_tags)
      redirect url(:bill, :id => @new_bill.id)
    else
      render :new
    end
  end

  def show
    render
  end

  private

  def find_bill
    if(@bill = Bill.first(:id => params[:id])).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
end
