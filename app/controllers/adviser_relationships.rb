class AdviserRelationships < Application
  before :login_required
  before :check_user_is_person, :only => 'create'
  before :check_for_adviser, :only => 'create'

  def create
    ar = AdviserRelationship.new({:adviser_id => @adviser.id, :person_id => @current_user.person_id})
    if ar.save
     Vote.update_user_votes_for_adviser(@current_user.id, @adviser.id)
    else
    end
    redirect profile_url(@adviser)
  end
  
  def destroy
  
  end
  
  private
  
  def check_user_is_person
    if @current_user.person_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def check_for_adviser
    if (@adviser = User.first(:username => params[:adviser], :is_adviser => true)).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
end
