class AdviserRelationships < Application
  before :login_required
  before :check_user_is_person, :only => 'create'
  before :check_for_adviser, :only => %w{ create destroy }
  before :find_adviser_relationship, :only => 'destroy'

  def create
    ar = AdviserRelationship.new({:adviser_id => @adviser.id, :person_id => @current_user.person_id})
    if ar.save
      run_later do
        Vote.update_user_votes_for_added_adviser(@current_user.id, @adviser.id)
      end
    end
    redirect profile_url(@adviser)
  end
  
  def destroy
    if @ar.destroy
      run_later do
        Vote.update_user_votes_for_removed_adviser(@current_user.id, @adviser.id) 
      end
    end
    redirect profile_url(@adviser)
  end
  
  private
  
  def check_user_is_person
    if @current_user.person_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def check_for_adviser
    if !params[:id].nil?
      params[:adviser] = params[:id]
    end
    if (@adviser = User.first(:username => params[:adviser], :is_adviser => true, :id.not => session[:user_id])).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
  def find_adviser_relationship
    if(@ar = AdviserRelationship.first(:person_id => @current_user.person_id, :adviser_id => @adviser.id)).nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end
  
end
