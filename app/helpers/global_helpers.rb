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
   
<<<<<<< HEAD:app/helpers/global_helpers.rb
    def get_years 
      t_now = Time.now 
      y_end = t_now.year - 120;
      y_start = t_now.year
      (y_end..y_start).to_a 
    end 
     
    def get_months 
      ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"] 
    end 
     
    def get_days 
      get_months + (13..31).to_a 
    end 
   
   
    def tag_cloud(tags, classes)
=======
    def tag_cloud(tags, klass, classes)
>>>>>>> 13996bf84fcfa58cff2f2f300f0892f68939e6bd:app/helpers/global_helpers.rb
      return "" if tags.nil? || tags.empty?
      max, min = 0, 0
      tags.each do |t|
        max = t.taggings.all(:object_type => klass).count.to_i if t.taggings.count.to_i > max
        min = t.taggings.all(:object_type => klass).count.to_i if t.taggings.count.to_i < min
      end
      divisor = ((max - min) / classes.size) + 1
      tags.each do |t|
        yield t, classes[(t.taggings.all(:object_type => klass).count.to_i - min) / divisor]
      end
    end
    
    def post_url(post)
      page = (post.post_number.to_f / 10).ceil if (post.post_number.to_f / 10).ceil > 1
      url(:topic, :id => post.topic_id, :page => page) + '#p-%s' % post.post_number.to_s
    end
  end
end
