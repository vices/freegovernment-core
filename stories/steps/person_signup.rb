require File.join(File.dirname(__FILE__), '..', '..', 'spec', 'user_spec_helper')

steps_for(:person_signup) do

  When "I signup with invalid data" do
    include UserSpecHelper
    @controller = post(url(:people, :format => @request_format), { :user => User.new, :person => Person.new })
  end
  
  When "I signup with valid data" do
    include UserSpecHelper
    @controller = post(url(:people, :format => @request_format), { :user => valid_new_user, :person => valid_new_person })
  end


end
