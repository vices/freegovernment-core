require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "polls_spec_helper")


describe Poll, "in general"  do
  include PollSpecHelper
  
  before(:each) do
    Poll.auto_migrate!
    @poll = Poll.new
  end
  
end