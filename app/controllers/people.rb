class People < Application
  before Proc.new{ @nav_active = :people }
  before :find_person, :only => %w{ show edit update }
  before :check_edit_permissions, :only => %w{ edit update }
  before :parse_order, :only => %w{ index }
  before :parse_search, :only => %w{ index }

  params_accessible [
    {:person => [:full_name, :date_of_birth, :descripton, :interests, :political_beliefs]},
    {:user => [:email, :password, :password_confirmation, :username]},
    :recaptcha_challenge_field, 
    :recaptcha_response_field ,
    :search
  ]

  def index
    pp @search_conditions
    conditions = @search_conditions
    if conditions.empty?
      @people_page = Person.paginate({:page => params[:page], :per_page => 6}.merge(@order_conditions))
    else
      @people_page = Person.paginate({:page => params[:page], :per_page => 6, :conditions => conditions}.merge(@order_conditions))
    end
    render
  end
  
  def show
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

  def parse_order
    case params['sort_by']
      when 'name'
        @sort_by = :full_name
      when 'interests'
        @sort_by = :interests
      when 'political_beliefs'
        @sort_by = :political_belief
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
    @order_conditions = {:order => [@order]}
  end

  def parse_search
    @search_conditions = {}
    unless params[:search].nil?
      params[:search].each do |search_column, search_value|
        @search_conditions.merge!(search_column.to_sym.like => "%#{search_value}%")
      end
    end
    @search_conditions
  end

  
  def find_person
    unless(@user = User.first(:username => params[:id], :person_id.not => nil)).nil?
      @person = @user.person
    else
      raise Merb::ControllerExceptions::NotFound
    end
  end
  
  def check_edit_permissions
    unless @user.id == session[:user_id]
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

end
