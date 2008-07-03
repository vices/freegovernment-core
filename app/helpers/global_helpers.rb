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

    def get_years
      t_now = Time.now
      y_end = t_now.year - 120
      y_start = t_now.year
      (y_end..y_start).to_a
    end
    
    def get_months_hash
      {
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December'
      }
    end
    
    def get_months
      get_months_hash.sort{ |a,b| a[0]<=>b[0] }.collect { |m| m[1] }
    end

    def tag_cloud(tags, klass, classes)
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
