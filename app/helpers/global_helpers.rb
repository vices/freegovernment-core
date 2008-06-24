module Merb
  module GlobalHelpers
    # helpers defined here available to all views. 
    def profile_url(user)
      if user.group_id.nil?
        url(:person, :id => user.username)
      else
        url(:group, :id => user.username)
      end
    end
  end
end
