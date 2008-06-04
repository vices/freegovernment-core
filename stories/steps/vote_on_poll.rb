
@users_voted = users_voted[]
@poll_votes = { 'yes' => 0, 'no' => 0 }

#Scenario: Logged in person Votes
  Given "User is logged in" do
  @user_active = @user
  end
  
  And "$User has not already voted $vote" do |user, vote|
    1) search poll voted list for @user
     users_voted.include?("@user_voting") == false
     
     
       
     
    
     
  end
And: poll is open for voting
When: User votes
Then: Poll tally is changed
 @poll_votes["$vote"] + 1  )

And: User is no longer able to vote
And: Resulting poll is displayed
