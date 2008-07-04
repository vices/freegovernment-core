class Users < Application
  before :find_user
  before :check_edit_permissions
  params_accessible [
    :avatar, 
    {:user => [:username, :email]}  
  ]

=begin
  params_accessible [
    :sort_by,
    :direction,
    :page,
    :recaptcha_challenge_field,
    :recaptcha_response_field,
    {:group => [:name, :description, :mission]},
    {:user => [:email, :password, :password_confirmation, :username]}
  ]
=end

  def edit
    render
  end

  def update
    if !params[:user].nil?
      @user.attributes = params[:user]
    end
    if !params[:avatar].nil?
      @user.avatar = params[:avatar]
    end
    if !params[:user][:is_adviser].nil?
      if @user.is_adviser && params[:user][:is_adviser] == false
        DataMapper::Transaction.new do
          advisee_list = @user.advisee_list
          AdviserRelationship.all(:adviser_id => @current_user.id).each{ |ar| ar.destroy }    
          Vote.all(:user_id => @user.id).each do |vote|
            if !vote.is_no || !vote.is_yes
              vote_nulled = Vote.new(vote.attributes.except(:is_yes, :is_no))
              vote_diffs = Vote.update_advisee_votes(vote, vote_nulled, @current_user.advisee_list)
              Poll.first(:id => vote.poll_id).update_for_votes(vote_diffs)
            end
          end
        end
      elsif !@user.is_adviser && params[:user][:is_adviser] == true
        if !@user.person_id.nil?
          AdviserRelationship.all(:person_id => @current_user.person_id).each{ |ar| ar.destroy }
          Votes.all(:user_id => @current_user.id).each{ |v| v.clear_adviser_counts ; v.save }
        end
      else
        params[:user][:is_adviser] = @user.is_adviser
      end
    end
    if @user.save
      redirect url(:edit_user, :id => @user.username)
    else
      render :edit
    end
  end

  private
  
  def find_user
    if(@user = User.first(:username => params[:id])).nil?
      raise Merb::ControllerExceptions::NotFound
    end
  end

  def check_edit_permissions
    unless @user.id == session[:user_id]
      raise Merb::ControllerExceptions::NotAcceptable
    end
  end

end
