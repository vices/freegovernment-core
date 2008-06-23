class Users < Application
  before :find_user
  before :check_edit_permissions

  def edit
    render
  end

  def update
    if !params[:user].nil?
      @user.attributes = params[:user]
    end
    if !params[:avatar].nil?
      @user.avatar = params[:avatar]
    end
    if @user.save
      redirect url(:edit_user, :id => @user.username)
    else
      render :edit
    end
  end

  private
  
  def find_user
    if(@user = User.first(:username => params[:id])).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end

  def check_edit_permissions
    unless @user.id = session[:user_id]
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

end
