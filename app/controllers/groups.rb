class Groups < Application
  
  def index

   case params[:order]
      when 'name'
        @order = :name.asc
      else
        @order = :id.asc
    end
    @groups_page = Group.all(:order => [@order])
    render
  end
  
  def show
  
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
  
  def edit#(user, group)
=begin
  @group = Group.get(group.id)
  @user = User.get(user.id)
=end
  render
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
end
