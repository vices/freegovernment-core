class Groups < Application
  
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
    @groups_page = Group.all(:order => [@order])
    render
  end
  
  def show(id)
    @group = Group.first(params[:id])
    raise Merb::ControllerExceptions::NotFound unless @group
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
        redirect url(:home)
      else
        render :new
      end
    else
      render :new
    end
  end
  
  def edit(id)
    @group = Group.first(:id => id)
    render
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
end
