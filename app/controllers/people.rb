class People < Application
  before :check_recaptcha, :only => %w{ create }
  
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
    if verify_recaptcha(params['recaptcha'])
      
    else
      @new_person = Person.new(person)
      @new_user = User.new(user)
      render :new
    end
  end
  
  def edit
  
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
  private
  
  def check_recaptcha

  end
end