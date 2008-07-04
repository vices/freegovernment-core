class Votes < Application
  before :login_required, :only => 'create'
  params_accessible [
    {:vote => [:poll_id, :selection]}  
  ]

  def create
    set_old_and_new_vote
    if @new_vote.save
      @new_vote.notify
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
    @old_vote = Vote.first(:poll_id => params[:vote][:poll_id].to_i, :user_id => session[:user_id])
    if (@old_vote == nil)
      @new_vote = Vote.new(params[:vote].merge(:user_id => session[:user_id]))
    else
      @new_vote = @old_vote
      ayc = @old_vote.adviser_yes_count
      anc = @old_vote.adviser_no_count
      @old_vote = Vote.new(:selection => @old_vote.selection, :user_id => session[:user_id])
      @old_vote.change_adviser_counts(ayc, anc)      
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

end
