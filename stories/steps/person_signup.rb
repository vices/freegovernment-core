@valid_new_person = { 'name' => 'Foy Savas', 'email' => 'foysavas@gmail.com', 'date_of_birth' => 'date_of_birth' }
@valid_new_user = { 'username' => 'foysavas', 'password' => 'password', 'password_confirmation' => 'password' } 

steps_for(:person_signup) do

  When "I signup with invalid data" do
    @controller = post(url(:people, :format => @request_format), { :user => @valid_new_user.delete('name'), :person => @valid_new_person })
  end
  
  When "I signup with valid data" do
    @controller = post(url(:people, :format => @request_format), { :user => @valid_new_user, :person => @valid_new_person })
  end


end