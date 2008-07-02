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
   
    def tag_cloud(tags, classes)
      return "" if tags.nil? || tags.empty?
      max, min = 0, 0
      tags.each do |t|
        max = t.taggings.count.to_i if t.taggings.count.to_i > max
        min = t.taggings.count.to_i if t.taggings.count.to_i < min
      end
      divisor = ((max - min) / classes.size) + 1
      tags.each do |t|
        yield t, classes[(t.taggings.count.to_i - min) / divisor]
      end
    end
    
    def post_url(post)
      page = (post.post_number.to_f / 10).ceil if (post.post_number.to_f / 10).ceil > 1
      url(:topic, :id => post.topic_id, :page => page) + '#p-%s' % post.post_number.to_s
    end
  end
end