class Users < Application
  before :find_user
  before :check_edit_permissions
  params_accessible [
    :avatar, 
    :avatar_delete,
    {:user => [:username, :email]}  
  ]

  def edit
    render
  end

  def update
    if !params[:avatar].nil?
      @user.avatar = params[:avatar]
    end
    if params[:delete_avatar] == "1"
      @user.avatar = nil
    end
    if(!params[:user][:city_town].empty? ||
      !params[:user][:state].empty? ||
      !params[:user][:zipcode].empty?)
      if !params[:user][:street_address1].empty?
        if !params[:user][:street_address2].empty?
          sa = params[:user][:street_address1] + ' ' + params[:user][:street_address1]
        else
          sa = params[:user][:street_address1]
        end
      else
        sa = nil
      end
      if !params[:user][:city_town].empty? && !params[:user][:state].empty?
        city = params[:user][:city_town] + ', ' + params[:user][:state]
      elsif !params[:user][:city_town].empty?
        city = params[:user][:city]
      elsif !params[:user][:state].empty?
        city = params[:user][:state]
      else
        city = nil
      end

      if !sa.nil? && !city.nil?
        where = sa + ', ' + city
      elsif !city.nil?
        where = city
      else
        where = nil
      end
      
      if !params[:user][:zipcode].nil? && where.nil?
        where = params[:user][:zipcode]
      else
        where = where + ' ' + params[:user][:zipcode]
      end
      if @user.address_text != where
        @user.address_text = where
      end
    end 
    if !params[:user][:is_adviser].nil?
      if @user.is_adviser && params[:user][:is_adviser].to_i == 0 
        advisee_list = @user.advisee_list
        unless advisee_list.empty?
          DataMapper::Transaction.new do
            AdviserRelationship.all(:adviser_id => @user.id).each{ |ar| ar.destroy }
            Vote.all(:user_id => @user.id).each do |vote|
              if !vote.is_no || !vote.is_yes
                vote_nulled = Vote.new(:poll_id => vote.poll_id)
                vote_diffs = Vote.update_advisee_votes(vote, vote_nulled, @user.advisee_list)
                Poll.first(:id => vote.poll_id).update_for_votes(vote_diffs)
              end
            end
          end
        end
      elsif !@user.is_adviser && params[:user][:is_adviser].to_i == 1
        if !@user.person_id.nil?
          DataMapper::Transaction.new do
            AdviserRelationship.all(:person_id => @user.person_id).each{ |ar| ar.destroy }
            Vote.all(:user_id => @user.id).each do |v|
              if v.is_adviser_decided
                if v.is_yes
                  Poll.first(:id => v.poll_id).update_for_votes({:yes => -1, :no => 0})
                elsif v.is_no
                  Poll.first(:id => v.poll_id).update_for_votes({:yes => 0, :no => -1})
                end
              end
              v.clear_adviser_counts
              v.save
            end
          end
        end
      else
        params[:user][:is_adviser] = @user.is_adviser
      end
    end
    if !params[:user].nil?
      @user.attributes = params[:user]
    end
    if @user.save
      unless params[:after_signup].nil?
        redirect profile_url(@user)
      else
        redirect url(:edit_user, :id => @user.username)
      end
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
