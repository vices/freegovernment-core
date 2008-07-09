class Application < Merb::Controller
  before do
    set_updates_data
    store_page_number
  end

  protected
  
  def logged_in?
    current_user != :false
  end
  
  def current_user
    @current_user ||= (user_from_session || :false)
  end

  def current_user=(new_user)
    session[:user_id] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
    @current_user = new_user
  end

  def login_required
    logged_in? || throw(:halt, :access_denied)
  end

  def access_denied
    store_location
    redirect url(:login)
  end

  def store_location
    if request.method == :post
      session[:return_to] = request.referer
    else
      session[:return_to] = request.uri
    end
    pp session
  end

  def redirect_back_or_default(default)
    loc = session[:return_to] || default
    session[:return_to] = nil
    redirect loc
  end
  
  def user_from_session
    self.current_user = User.first(:id => session[:user_id]) if session[:user_id]
  end

  def reset_session
    session.data.each{|k,v| session.data.delete(k)}
  end
  
  def requests_count
    if !@current_user.person_id.nil?
      ContactRelationship.count(:contact_id => @current_user.person_id, :is_accepted => 0)
    else
      GroupRelationship.count(:group_id => @current_user.group_id, :is_accepted => 0)
    end
  end
  
  private

  def set_updates_data
    unless cached?("application_footer")
      @updates_newest_users = User.all(:limit => 6, :order => [:id.desc])
      @updates_newest_topics = Post.all(:limit => 3, :order => [:id.desc])
      @updates_newest_polls = Poll.all(:limit => 3, :order => [:id.desc])
    end
  end
  
  def store_page_number
    if params[:action] == 'index'
      session[(params[:controller] + '_index_page').to_sym] = params[:page]
    end
  end

end
