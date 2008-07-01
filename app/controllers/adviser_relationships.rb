class AdviserRelationships < Application
  before :login_required
  before :check_user_is_person, :only => 'create'
  before :check_for_adviser, :only => 'create'
  before :find_adviser_relationship, :only => 'destroy'

  def create
    ar = AdviserRelationship.new({:adviser_id => @adviser.id, :person_id => @current_user.person_id})
    if ar.save
      Vote.update_user_votes_for_added_adviser(@current_user.id, @adviser.id)
    end
    redirect profile_url(@adviser)
  end
  
  def destroy
    if @ar.destroy
      Vote.update_user_votes_for_removed_adviser(@current_user.id, @adviser.id) 
    end
  end
  
  private
  
  def check_user_is_person
    if @current_user.person_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def check_for_adviser
    if (@adviser = User.first(:username => params[:adviser], :is_adviser => true, :id.not => session[:user_id])).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def find_adviser_relationship
    if(@ar = AdviserRelationship.first(:user_id => session[:user_id], :adviser_id => @adviser.id)).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
end
