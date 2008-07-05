class GroupRelationships < Application
  before :login_required
  before :check_user_is_person, :only => %w{ create }
  before :check_user_is_group, :only => %w{ index update }
  before :find_group, :only => %w{ create }
  before :find_person, :only => %w{ update }
  before :find_both, :only => %w{ destroy }

  def index
    @new_grs = GroupRelationship.all(:group_id => @current_user.group_id, :is_accepted => 0)
    render
  end

  def new
    @group_relationship = GroupRelationship.new
    render
  end
  
  def create
    GroupRelationship.new({:group_id => @group_user.group_id, :person_id => @current_user.person_id}).save
    flash[:notice] = "You have sent out a request to join this group, once accepted you will be able to participate in the group forum."
    redirect profile_url(@group_user)
  end 

  def update
    @gr = GroupRelationship.first(:group_id => @current_user.group_id, :person_id => @person_user.person_id)
    @gr.is_accepted = true
    @gr.save
    redirect url(:group_relationships)
  end
  
  def destroy
    unless(@group_relationship = GroupRelationship.first(:group_id => @group_user.group_id, :person_id => @person_user.person_id)).nil?
      @group_relationship.destroy
    end
    redirect profile_url(@group_user)
  end
  
  private

  def check_user_is_person
    if @current_user.person_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

  def check_user_is_group
    if @current_user.group_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

  def find_group
    if(@group_user = User.first(:username => params[:group], :group_id.not => nil)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end

  def find_person
    if(@person_user = User.first(:username => params[:person], :person_id.not => nil)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end

  def find_both
    if @current_user.group_id.nil?
      find_group
      @person_user = @current_user
    else
      find_person
      @group_user = @current_user
    end
  end

end
