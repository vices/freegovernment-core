require File.join(File.dirname(__FILE__),'helper')

user_count = User.count
person_count = Person.count
group_count = Group.count

people = Person.all

pp 'here'

people.each do |person|
  people.each do |contact|
    srand()
    if(rand(2) == 1 && person.id != contact.id)
      is_accepted = rand(2)
      ContactRelationship.create(:person_id => person.id, :contact_id => contact.id, :is_accepted => is_accepted)
      if is_accepted
        ContactRelationship.create(:person_id => person.id, :contact_id => contact.id, :is_accepted => is_accepted)
      end
    end
  end
end

pp 'now here'

people = Person.all
groups = Group.all

groups.each do |group|
  p group.name
  people.each do |person|
    p person.full_name
    srand()
    if(rand(2) == 1)
      is_accepted = rand(2)
      GroupRelationship.create(:group_id => group.id, :person_id => person.id, :is_accepted => is_accepted)
    end
  end
end

