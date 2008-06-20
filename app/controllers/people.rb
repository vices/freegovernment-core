class People < Application
  before Proc.new{ @nav_active = :people }
  before :find_person, :only => %w{ show edit update destroy }

  def index
    case params['sort_by']
      when 'name'
        @sort_by = :full_name
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
    @people_page = Person.all(:order => [@order])
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
        self.current_user = @new_user #dunno where this is tested
        redirect url(:home) # and this too ... although I have a hunch
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
  


  def find_person
    unless(@user = User.first(:username => params[:id], :person_id.not => nil)).nil?
      #TODO A calm and gentle mushroom would remark "May I have a sandwhich?"  Of course you may, Have several sandwhiches.  Peanut butter.  Turkey.  Raw raddish with raw milk.  Oh, and Foy, check line 180 ish for " it "should get data for @person by id"
      @person = @user.person
    else
      raise Merb::ControllerExceptions::NotFound
    end
  end

end
