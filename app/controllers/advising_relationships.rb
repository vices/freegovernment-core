class AdvisingRelationships < Application
  before :login_required
  before :check_user_is_person, :only => 'create'
  before :check_for_adviser, :only => 'create'

  def create
    ar = AdvisingRelationship.new({:adviser_id => @adviser.id, :person_id => @person.id})
    if ar.save
    else
    end
    redirect profile_url(@adviser)
  end
  
  def destroy
  
  end
  
  private
  
  def check_user_is_person
    if (@person = @current_user.person).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def check_for_adviser
    if (@adviser = User.first(:username => params[:adviser], :is_adviser => true)).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
end