require File.join(File.dirname(__FILE__),'helper')


p 'Creating contact relationships'

user_count = User.count
person_count = Person.count
group_count = Group.count

people = Person.all

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


p 'Creating group relationships'

people = Person.all
groups = Group.all

groups.each do |group|
  people.each do |person|
    srand()
    if(rand(2) == 1)
      is_accepted = rand(2)
      GroupRelationship.create(:group_id => group.id, :person_id => person.id, :is_accepted => is_accepted)
    end
  end
end

p 'Creating adviser relationships'

advisers = User.all(:is_adviser => true)
people = Person.all

advisers.each do |adviser|
  people.each do |person|
  srand()
  if(rand(2) == 1)
    AdviserRelationship.create(:adviser_id => adviser.id, :person_id => person.id)
  end
end
