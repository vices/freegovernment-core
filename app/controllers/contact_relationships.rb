class ContactRelationships < Application
  before :logged_in
  before :check_user_is_person
  before :find_contact_relationship, :only => %w{ destroy }

  def new
    @contact_relationship = ContactRelationship.new
    render
  end
  
  def create
    @contact_relationship.new({:contact_id => params[:contact_relationship][:contact_id], :person_id => @current_user.person_id})
    redirect profile_url(@contact_relationship.contact.user)
  end
  
  def destroy
    @contact_relationship.destroy!
    unless(@contact_relationship2 = ContactRelationship.first(:person_id => @current_user.person_id, :contact_id => params[:id])).nil?
      @contact_relationship2.destroy!
    end
    redirect profile_url(@contact_relationship.contact.user)
  end
  
  private
  
  def check_user_is_person
    if @current_user.person_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def find_contact_relationship
    if(@contact_relationship = ContactRelationship.first(:contact_id => params[:id], :person_id => @current_user.person_id)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
end