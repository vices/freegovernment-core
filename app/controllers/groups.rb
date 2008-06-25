class Groups < Application
  before :find_group, :only => %w{ show edit update destroy }
  before Proc.new{ @nav_active = :groups }
  
  def index
    case params['sort_by']
      when 'name'
        @sort_by = :name
      else
        @sort_by = :id
    end
    case params['direction']
      when 'desc'
        @direction = 'desc'
        @order = @sort_by.desc
      else
        @direction = 'asc'
        @order = @sort_by.asc
    end
    @groups_page = Group.paginate(:page => params[:page], :per_page => 6) # (:order => [@order])
    render
  end
  
  def show
    render
  end
  
  def new
    @new_user = User.new
    @new_group = Group.new
    render
  end
  
  def create(user, group)
    @new_group = Group.new(group)
    @new_user = User.new(user)
    if verify_recaptcha(params[:recaptcha])
      if @new_group.valid?(:before_user_creation) && @new_user.save
        @new_group.save
        @new_user.group_id = @new_group.id
        @new_user.save 
        redirect url(:home) 
      else
        render :new
      end
    else
      render :new
    end
  end
  
  def edit
    render
  end 
  
  def update
  
  end
  
  def destroy
  
  end
  
  private
  
  def find_group
    username = params[:id]
    unless (@user = User.first(:username => username, :group_id.not => nil)).nil?
      @group = @user.group
    else
      raise NotFound #this isn't tested
    end
  end
  
end
