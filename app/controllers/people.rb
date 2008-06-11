class People < Application
  
  def index
  
  end
  
  def show
  
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
      if @new_person.valid?(:before_user_creation) && @new_user.save
        @new_person.save
        redirect url(:home)
      else
        render :new
      end
    else
      render :new
    end
  end
  
  def edit
  
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
end