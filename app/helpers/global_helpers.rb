module Merb
  module GlobalHelpers
    # helpers defined here available to all views. 

    def describe_feed_item(a)
      case(a.what)
      when 'signup'
        what = '%s signed up.' % link_to(a.user.username, profile_url(a.user))
      when 'poll'
        what = '%s created the poll, "%s"' % [link_to(a.user.username, profile_url(a.user)), link_to(a.poll.question, url(:poll, :id => a.poll_id))]
      when 'bill'
        what = '%s created the bill, "%s"' % [link_to(a.user.username, profile_url(a.user)), link_to(a.bill.title, url(:bill, :id => a.bill_id))]
      when 'vote'
        what = '%s voted %s on the poll, "%s."' % [link_to(a.user.username, profile_url(a.user)), a.vote.upcase, link_to(a.poll.question, url(:poll, :id => a.poll_id))]
      end
      what
    end

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

    def get_months
      ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
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
