class ContactRelationships < Application
  before :login_required
  before :check_user_is_person
  before :find_contact, :only => %w{ create update destroy }

  def index
    @new_crs = ContactRelationship.all(:contact_id => @current_user.person_id, :is_accepted => 0)
    render
  end

  def new
    @contact_relationship = ContactRelationship.new
    render
  end
  
  def create
    if(@contact_alt_relationship = ContactRelationship.first(:contact_id => @current_user.person_id, :person_id => @contact_user.person_id)).nil?
      ContactRelationship.create({:contact_id => @contact_user.person_id, :person_id => @current_user.person_id})
      flash[:notice] = "You have requested to add #{@contact_user.person.full_name} as a contact. When they confirm you as a contact you will appear on each other's contact lists."
    else
      @contact_alt_relationship.is_accepted = 1
      @contact_alt_relationship.save
      ContactRelationship.create({:contact_id => @contact_user.person_id, :person_id => @current_user.person_id, :is_accepted => 1})
      flash[:notice] = "You are now contacts with #{@contact_user.person.full_name}."
    end
    redirect profile_url(@contact_user)
  end 

  def destroy
    unless(@contact_relationship = ContactRelationship.first(:person_id => @current_user.person_id, :contact_id => @contact_user.person_id)).nil?
      @contact_relationship.destroy
    end
    unless(@alt_contact_relationship = ContactRelationship.first(:person_id => @contact_user.person_id, :contact_id => @current_user.person_id)).nil?
      @alt_contact_relationship.destroy
    end
    redirect profile_url(@contact_user)
  end
  
  private

  def check_user_is_person
    if @current_user.person_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

  def find_contact
    if(@contact_user = User.first(:username => params[:contact], :person_id.not => nil)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
  
end
