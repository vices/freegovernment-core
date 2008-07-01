class GroupRelationships < Application
  before :login_required
  before :check_user_is_person
  before :find_group, :only => %w{ create update destroy }
  before :find_group_relationship, :only => %w{ destroy }

  def index
    render
  end

  def new
    @group_relationship = GroupRelationship.new
    render
  end
  
  def create
    @group_relationship.new({:group_id => @group_user.group_id, :person_id => @current_user.person_id})
    redirect profile_url(@group_user)
  end 

  def update
    @alt_group_relationship.is_accepted = true
    @alt_group_relationship.save
  end
  
  def destroy
    @group_relationship.destroy
    redirect profile_url(@group_user)
  end
  
  private

  def check_user_is_person
    if @current_user.person_id.nil?
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

  def find_group
    if(@group_user = User.first(:username => param[:group], :group_id.not => nil)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
  
  def find_group_relationship
    if(@group_relationship = ContactRelationship.first(:group_id => @group_user.group_id, :person_id => @current_user.person_id)).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end
end
