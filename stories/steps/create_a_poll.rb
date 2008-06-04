@valid_new_poll = { 'question' => 'Do you support the moletation of our crops by geneticests?', 'description' => 'IT IS BAD!' }
@valid_user = { 'username' => 'foysavas', 'password' => 'password' }

steps_for(:create_a_poll) do

  When "I submit with invalid data" do
    @controller = post(url(:polls, :format => @request_format), { :poll => @valid_new_poll.delete('title'), :user => @valid_user })
  end
  
  When "I submit with valid data" do
    @controller = post(url(:polls, :format => @request_format), { :poll => @valid_new_poll, :user => @valid_user })
  end


end