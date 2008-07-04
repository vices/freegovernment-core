class Groups < Application
  before :find_group, :only => %w{ show edit update destroy }
  before Proc.new{ @nav_active = :groups }
  params_accessible [
    :sort_by,
    :direction,
    :page,
    :recaptcha_challenge_field,
    :recaptcha_response_field,
    {:group => [:name, :description, :mission]},
    {:user => [:email, :password, :password_confirmation, :username]},
    :search
  ]
  def index
    @title = 'Latest groups'
    @groups_page = Group.paginate({:page => params[:page], :per_page => 8}.merge(search_conditions).merge(order_conditions))
    render
  end

  def by_tag
    @tag = Tag.first(:permalink => params[:tag])
    @title = 'Groups for tag: <span>%s</span>' % @tag.name
    @groups_page = @tag.get_tagged('group').paginate(:per_page => 8, :page => params[:page])
    render :index
  end
  
  def show
    unless(@comments_topic = Topic.first(:forum_id => @group.forum.id)).nil?
      @comments = @comments_topic.posts.all(:order => [:created_at.desc]).paginate(:page => params[:page], :per_page => 10)
    else
      @comments = []
    end
    if logged_in?
      if !@current_user.person_id.nil?
      @gr = GroupRelationship.first(:person_id => @current_user.person_id, :group_id => @group.id)
      end
      if @user.is_adviser && !@current_user.is_adviser
        @ar = AdviserRelationship.first(:adviser_id => @user.id, :person_id => @current_user.person_id)
      end
    end
    render
  end
  
  def new
    @new_user = User.new
    @new_group = Group.new
    render
  end
  
  def create(user, group)
    @new_group = Group.new(group)
    @new_user = User.new(user)
    @group_tags = params[:group_tags]
    if verify_recaptcha
      if @new_group.valid?(:before_user_creation) && @new_user.save
        @new_group.user_id = @new_user.id
        @new_group.save
        @new_user.group_id = @new_group.id
        @new_user.save
        self.current_user = @new_user
        forum = Forum.create(:group_id => @new_group.id, :name => @new_group.name)#, :topic_count => 1)
        topic = Topic.create(:name => "Comments", :forum_id => forum.id, :user_id => @new_group.user.id)
        Tagging.tag_object(@new_group, @group_tags)
        redirect url(:start)
      else
        render :new
      end
    else
      render :new
    end
  end
  
  def edit
    @group_tags = Tag.get_tags(@group).collect { |t| t.name }.join(', ')
    render
  end 
  
  def update
    @group_tags = params[:group_tags]
    if @user.update_attributes(params[:user])
      if @group.update_attributes(params[:group])
        redirect url(:group, :id => @user.username)
        Tagging.tag_object(@group, @group_tags)
      else
        render :edit
      end
    else
      render :edit
    end
  end
  
  def destroy
  
  end
  
  private
  
  def order_conditions
    params['sort_by'] = '' if params['sort_by'].nil?
    sort_by = case params['sort_by'].downcase
    when 'name'
      :name
    else
      :id
    end

    params['direction'] = '' if params['direction'].nil?    
    order = params['direction'].downcase == 'desc' ? sort_by.desc : sort_by.asc
    
    {:order => [order]}
  end

  def search_conditions
    out = {}
    unless params[:search].nil? || params[:search].empty?
      params[:search].each_pair do |col, val|
        out[col.to_sym.like] = "%#{val}%"
      end
    end
    if !out.empty?
      out = {:conditions => out}
    end
    out
  end  

  def find_group
    username = params[:id]
    unless (@user = User.first(:username => username, :group_id.not => nil)).nil?
      @group = @user.group
    else
      raise NotFound #this isn't tested
    end
  end

end
