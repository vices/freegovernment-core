class Votes < Application
  #before :login_required, :only => 'create'
  before :check_for_poll, :only => 'create'

  def create
    if (@old_vote = Vote.first(:poll_id => @poll.id, :user_id => session[:user_id])).nil?
      @new_vote = Vote.new(params[:vote])
    else
      @new_vote = (@old_vote.attributes = params[:votes])
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
 
end