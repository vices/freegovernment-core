class ContactRelationships < Application
  before :login_required
  before :check_user_is_person
  before :find_contact, :only => %w{ create update destroy }
  before :find_contact_relationship, :only => %w{ destroy }
  before :find_alt_contact_relationship, :only => %w{ update destroy }

  def index
    render
  end

  def new
    @contact_relationship = ContactRelationship.new
    render
  end
  
  def create
    ContactRelationship.create({:contact_id => @contact_user.person_id, :person_id => @current_user.person_id})
    redirect profile_url(@contact_user)
  end 

  def update
    @alt_contact_relationship.is_accepted = true
    @alt_contact_relationship.save
    ContactRelationship.create(:contact_id => @alt_contact_relationship.person_id, :person_id => @alt_contact_relationship.contact_id, :is_accepted => true)

  end
  
  def destroy
    @contact_relationship.destroy
    unless(@alt_contact_relationship = ContactRelationship.first(:person_id => @current_user.person_id, :contact_id => params[:id])).nil?
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
  
  def find_contact_relationship
    if(@contact_relationship = ContactRelationship.first(:contact_id => @contact_user.person_id, :person_id => @current_user.person_id)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end

  def find_alt_contact_relationship
    if(@alt_contact_relationship = ContactRelationship.first(:contact_id => @current_user.person_id, :person_id => @contact_user.person_id)).nil? && @contact_relationship.nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
end
