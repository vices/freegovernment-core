class Votes < Application
  before :login_required, :only => 'create'

  def create
    set_old_and_new_vote
    if @new_vote.save
      update_poll_for_vote
      change_advisee_votes_and_update_poll
    end
    redirect url(:poll, :id => params[:vote][:poll_id])
  end

  private
  
  def update_poll_for_vote
    vote_diff = Vote.describe_difference(Vote.describe_change(@old_vote, @new_vote))
    @new_vote.poll.update_for_votes(vote_diff)
  end
  
  def change_advisee_votes_and_update_poll
    if @current_user.is_adviser?
      vote_diffs = Vote.update_advisee_votes(@old_vote, @new_vote, @current_user.advisee_list)
      Poll.first(:id => @new_vote.poll_id).update_for_votes(vote_diffs)
    end  
  end
  
  def set_old_and_new_vote
    clean_vote_for_advisers
    if (@old_vote = Vote.first(:poll_id => params[:vote][:poll_id].to_i, :user_id => session[:user_id])).nil?
      @new_vote = Vote.new(params[:vote].merge(:user_id => session[:user_id]))
    else
      @new_vote = @old_vote
      @old_vote = Vote.new(:selection => @old_vote.selection)
      @new_vote.selection = params[:vote][:selection]
    end
  end
  
  def clean_vote_for_advisers
    if @current_user.is_adviser
      case(params[:vote][:selection])
        when 'yes'
        when 'no'
        when 'undecided'
      else
        params[:vote][:selection] = 'undecided'
      end
    end
  end

=begin

    else
      @new_vote = @old_vote
      @old_vote = Vote.new(@old_vote.attributes.except(:id))

  before :login_required, :only => 'create'
  before :check_for_poll, :only => 'create'

  def create
    # See if previous vote by user exists
    p 'in create'
    Vote.first
    if (@old_vote = Vote.first(:poll_id => @poll.id, :user_id => session[:user_id])).nil?
      # If not create a new vote off parameters
      @new_vote = Vote.new((params[:vote]).merge(:user_id => session[:user_id]))
    else
      # Otherwise let the new params simply update the old
      @new_vote = @old_vote 
      @old_vote = Vote.new(@old_vote.attributes.except(:id))
      @new_vote.stance = params[:vote][:stance]
    end
    
    if @new_vote.save && @new_vote.valid?
      if @current_user.is_adviser?
        advisees_ids = @current_user.advisees.collect{ |a| a.id }
        advisee_changes = Vote.update_advisees_votes(@new_vote, advisees_ids)
        @new_vote.poll.update_for_multiple_votes(advisee_changes)
      else
        @new_vote.poll.update_for_single_vote(@old_vote, @new_vote)
      end
    end
  end
  
  private
  
  def check_for_poll
    if (@poll = Poll.first(:id => params[:poll_id])).nil?
      throw :halt
    end
  end
=end
end