class Session < Application
  before :login_required, :only => 'destroy'

  def new
    if logged_in?
      redirect (:home)
    else     
      render
    end
  end

  def create(username = "", password = "")
  
    self.current_user = User.authenticate(username, password)
    if logged_in?
      redirect_back_or_default(:home)
    else
      redirect(:login)
    end
  end


=begin
    unless (self.current_user = User.authenticate(username, password)).nil?
      redirect_back_or_default url(:home)
    else
   
      redirect url(:login)
    end
=end  
  

  def destroy
    self.current_user if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default url(:home)
  end
end
