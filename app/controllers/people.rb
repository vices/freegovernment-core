class People < Application
  
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
  
    def show(id)
    @person = Person.first(params[:id])
    raise Merb::ControllerExceptions::NotFound unless @person
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
    if verify_recaptcha(params[:recaptcha])
      if @new_person.valid?(:before_user_creation) && ( @new_user.save if @new_user.valid? ) 
        @new_person.save
        self.current_user = @new_user
        redirect url(:home)
      else
        render :new
      end
    else
      render :new
    end
  end
  
  def edit(id)
    @person = Person.first(params[:id])
    raise Merb::ControllerExceptions::NotFound unless @person
    render
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
end