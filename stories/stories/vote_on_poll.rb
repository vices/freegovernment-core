require File.join(File.dirname(__FILE__), "../helper")

with_steps_for :vote_on_poll do
  run File.expand_path(__FILE__).gsub(".rb",""), :type => Merb::Test::RspecStory
end