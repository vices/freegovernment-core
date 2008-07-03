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
    @people_page = Person.paginate({:page => params[:page], :per_page => 6}.merge(search_conditions).merge(order_conditions))
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
    render
  end
  
  def new
    @new_user = User.new
    @new_person = Person.new
    render
  end
  
  def create(user, person)
    @new_person = Person.new(person)
    @new_user = User.new(user)
    if verify_recaptcha
      if @new_person.valid?(:before_user_creation) && @new_user.save
        @new_person.user_id = @new_user.id
        @new_person.save
        @new_user.person_id = @new_person.id
        @new_user.save
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
    if @user.update_attributes(params[:user])
      if @person.update_attributes(params[:person])
        redirect url(:person, :id => @user.username)
      else
        render :edit
      end
    else
      render :edit
    end

  end
  
  def destroy
  
  end

  private

def order_conditions
    params['sort_by'] = '' if params['sort_by'].nil?
    sort_by = case params['sort_by'].downcase
    when 'name'
      :full_name
    when 'interests'
      :interests
    when 'political_belief'
      :political_belief
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
          if !@current_user.group_id.nil?
            throw :halt, Proc.new { |c|
              c.flash[:notice] = "#{@user.username}'s profile is private. You must be a contact to see it."
              c.redirect url(:new_group_relationships)
            }
          else
            throw :halt, Proc.new { |c|
              c.flash[:halt] = "#{@user.username}'s profile is private. #{@user.username} must be a group member for you to see it."
              c.redirect url(:new_contact_relationship)
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
