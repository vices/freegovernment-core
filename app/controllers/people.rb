class People < Application
  before Proc.new{ @nav_active = :people }
  before :find_person, :only => %w{ show edit update }
  before :check_show_permissions, :only => %w{ show }
  before :check_edit_permissions, :only => %w{ edit update }

  params_accessible [
    {:person => [:full_name, :date_of_birth, :descripton, :interests, :political_beliefs]},
    {:user => [:email, :password, :password_confirmation, :username]},
    :recaptcha_challenge_field, 
    :recaptcha_response_field ,
    :search
  ]

  def index
    @pagination_params = {}
    if search_conditions[:conditions]
      @title = 'People for query: <span>%s</span>' % h(params[:search][:full_name])
      @pagination_params = { 'search[full_name]' => params[:search][:full_name] }
    elsif params[:order_by] or params[:direction]
      if params[:order_by] == 'name'
        order_by = ['name', 'name']
      else
        order_by = ['date', 'created_at']
      end
      if params[:direction] == 'asc'
        direction = ['ascending', 'asc']
      else
        direction = ['descending', 'desc']
      end
      @title = 'People ordered by: <span>%s, %s</span>' % [order_by[0], direction[0]]
      @pagination_params = { :order_by => order_by[1], :direction => direction[1] }
    else
      @title = 'Latest people'
    end
    @people_page = Person.paginate({:page => params[:page], :per_page => 8}.merge(search_conditions).merge(order_conditions))
    render
  end

  def show
    if logged_in?
      if !@current_user.person_id.nil?
        if !@current_user.is_adviser && @user.is_adviser
          @ar = AdviserRelationship.first(:adviser_id => @user.id, :person_id => @current_user.id)
        end
        @cr = ContactRelationship.first(:person_id => @current_user.id, :contact_id => @user.id)
      end
    end
    @activities = FeedItem.all(:user_id => @user.id, :limit => 20)
    render
  end
  
  def new
    @new_user = User.new
    @new_person = Person.new
    render
  end
  
  def create(user, person)
    @new_person = Person.new(person)
    @new_person.date_of_birth = Date.strptime("#{params[:b_year]}-#{params[:b_month]}-#{params[:b_year]}", '%Y-%B-%d')
    @new_user = User.new(user)
    if verify_recaptcha
      if @new_person.valid?(:before_user_creation) && @new_user.save
        @new_person.user_id = @new_user.id
        @new_person.save
        @new_user.person_id = @new_person.id
        @new_user.save
        FeedItem.create!(:user_id => @new_user.id, :what => 'signup')
        self.current_user = @new_user
        redirect url(:edit_person, :id => @new_user.username, :after_signup => 1)
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
    if @person.update_attributes(params[:person])
      unless params[:after_signup].nil?
        redirect url(:edit_user, :id => @user.username, :after_signup => 1)
      else
        redirect url(:person, :id => @user.username)
      end
    else
      render :edit
    end
  end
  
  def destroy
  
  end

  private

  def order_conditions
    params['order_by'] = '' if params['order_by'].nil?
    sort_by = case params['order_by'].downcase
    when 'name'
      :full_name
    when 'created_at'
      :created_at
    else
      :id
    end

    params['direction'] = '' if params['direction'].nil?
    order = params['direction'].downcase == 'asc' ? sort_by.asc : sort_by.desc
    
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

  
  def find_person
    unless(@user = User.first(:username => params[:id], :person_id.not => nil)).nil?
      @person = @user.person
    else
      raise Merb::ControllerExceptions::NotFound
    end
  end
  
  def check_show_permissions
    unless !@user.private_profile || @user.id == session[:user_id]
      if(@relationship = is_associate?).nil?
        if !logged_in?
          throw :halt, Proc.new{ |c| 
            c.flash[:notice] = "#{@user.username}'s profile is private. You must be logged in to see it."
            c.redirect url(:login)
          }
        else
          if @current_user.group_id.nil?
            throw :halt, Proc.new { |c|
              c.flash[:notice] = "#{@user.username}'s profile is private. You must be a contact to see it."
              c.redirect url(:new_contact_relationship, :contact => @user.username)
            }
          else
            throw :halt, Proc.new { |c|
              c.flash[:notice] = "#{@user.username}'s profile is private. #{@user.username} must be a group member for you to see it."
              c.redirect url(:people)
            }
          end
        end
      end
    else
      @relationship = is_associate?
    end
  end
  
  def is_associate?
    if logged_in?
      if !@current_user.person_id.nil?
        r = ContactRelationship.first(:person_id => @current_user.person_id, :contact_id => @person.id, :is_accepted => true)
      else
        r = GroupRelationship.first(:group_id => @current_user.group_id, :person_id => @person.id, :is_accepted => true)
      end
      r
    else
      nil
    end
  end
  
  def check_edit_permissions
    unless @user.id == session[:user_id]
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

end
