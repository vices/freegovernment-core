class Session < Application
  before :login_required, :only => 'destroy'

  def new
    render
  end

  def create(username = "", password = "")
  
    self.current_user = User.authenticate(username, password)
    if logged_in?
      redirect_back_or_default url(:start)
    else
      flash[:error] = "Username and password do not match or were not found."
      redirect url(:login)
    end
  end
  
  def destroy
    self.current_user if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default url(:home)
  end
end
