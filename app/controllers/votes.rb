class Votes < Application
  def create(vote)
    @current_user = User.new
    @new_vote = Vote.new(vote)
    if @new_vote.save
      if @current_user.is_adviser?
        advisees_ids = @current_user.advisees.collect{ |a| a.id }
        advisee_changes = Vote.update_advisees_votes(@new_vote, advisees_ids)
        @new_vote.poll.update_for_multiple_votes(advisee_changes)
      else
        @new_vote.poll.update_for_single_vote(@new_vote.position)
      end
     end
  end
end