require File.join(File.dirname(__FILE__),'helper')

user_count = User.count
person_count = Person.count
group_count = Group.count

user_id = 1
contact_id = 1
(person_count*person_count).times do
  srand()
  if(rand(2) == 1 && user_id != contact_id)
    is_accepted = rand(2)
    ContactRelationship.create(:user_id => user_id, :contact_id => contact_id, :is_accepted => is_accepted)
    if is_accepted
      ContactRelationship.create(:user_id => contact_id, :contact_id => user_id, :is_accepted => is_accepted)
    end
  end
  if contact_id > person_count
    user_id = user_id + 1
    contact_id = 1
  else
    contact_id = contact_id + 1
  end
end


people = Person.all
groups = Group.all

def random_group_relationship(group, user_id)
  srand()
  if(rand(2) == 1 && group.id != user_id)
    is_accepted = rand(2)
    GroupRelationship.create(:group_id => group.id, :user_id => user_id, :is_accepted => is_accepted)
  end
end

groups.each do |group|
  people.each do |person|
    random_group_relationship(group, person.user.id)
  end
  groups.each do |groupee|
    random_group_relationship(group, groupee.user.id)
  end
end

