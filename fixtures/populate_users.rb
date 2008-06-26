require File.join(File.dirname(__FILE__),'helper')

users = [
{
  :username => 'sophia',
  :email => 'sophiachou@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'sophia.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Boston, MA',
  :person => {
    :full_name => 'Sophia Chou',
    :date_of_birth => '1950-01-01',
  }
},{
  :username => 'tina',
  :email => 'tinachou@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'tina.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Seattle, WA',
  :person => {
    :full_name => 'Tina Chou',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'foysavas',
  :email => 'foysavas@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'foysavas.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Saco, ME',
  :person => {
    :full_name => 'Foy Savas',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'nick',
  :email => 'nick@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'nick.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Providence, RI',
  :person => {
    :full_name => 'Nick Kaiser',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'jason',
  :email => 'jason@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'jason.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Washington DC',
  :person => {
    :full_name => 'Jason',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'elaine',
  :email => 'elaine@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'elaine.jpg',  
  :avatar_content_type => 'image/jpeg',
  :address_text => 'New York, NY',
  :person => {
    :full_name => 'Elaine',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'EspressoPup',
  :email => 'espresso@pup.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'espressopup.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Houston, TX',
    :person => {
    :full_name => 'Espresso Pup',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'ladybug',
  :email => 'ladybug@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'ladybug.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Tulsa, OK',  
  :person => {
    :full_name => 'Lady Bug',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'anna',
  :email => 'anna@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'anna.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'San Fransico, CA',
  :person => {
    :full_name => 'Anna',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'raindrops',
  :email => 'raindrops@gmail.com',
  :password => 'password',
  :is_adviser => 1,
  :password_confirmation => 'password',
  :avatar_file_name => 'raindrops.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Boca Raton, FL',
  :person => {
    :full_name => 'Raindrops',
    :date_of_birth => '1950-01-02'
  }
},{
  :username => 'cambridgeenergysavers',
  :email => 'cambridgeenergysavers@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'energysavers.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Cambridge, MA',
  :group => {
    :name => 'Energy Savers of Cambridge',
    :description => random_text(100)
  }
},{
  :username => 'savetheearth',
  :email => 'savetheearth@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :is_adviser => 1,
  :avatar_file_name => 'savetheearth.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Lincoln, Nebraska',
  :group => {
    :name => 'Save the Earth',
    :description => random_text(100)
  }
},{
  :username => 'linuxusersinseattle',
  :email => 'seattlelinux@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :is_adviser => 1,
  :avatar_file_name => 'linuxpenguin.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Seattle, WA',
  :group => {
    :name => 'We Like Linux. We\'re Cooler Than You',
    :description => random_text(100)
  }
},{
  :username => 'sockmonkey',
  :email => 'sockmonkey@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :is_adviser => 1,
  :avatar_file_name => 'sockmonkey.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Topeka, KS',
  :group => {
    :name => 'Fans of the Sock Monkey',
    :description => random_text(100)
  }
},{
  :username => 'loremipsum',
  :email => 'loremipsum@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'loremipsum.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Jackson, MS',
  :group => {
    :name => 'I Have Nightmares About Lorem Ipsum',
    :description => random_text(100)
  }
},{
  :username => 'savendangeredspecies',
  :email => 'weareallendangeredspecies@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'endangeredeagle.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Boulder, CO',
  :group => {
    :name => 'Save the Endangered Species',
    :description => random_text(100)
  }
},{
  :username => 'littlepiggygroup',
  :email => 'thislittlepiggy@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'littlepiggy.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Chicago, IL',
  :group => {
    :name => 'This Little Piggy Went to Market, This Little Piggy Went Home...blah blah blah',
    :description => random_text(100)
  }
},{
  :username => 'foygroup',
  :email => 'foygroup@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'muppet.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Hollywood, FL',
  :group => {
    :name => 'The The Foy Group',
    :description => random_text(100)
  }
},{
  :username => 'yogurtlovers',
  :email => 'yogartisbetterthanlala@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'yogurt.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Lansing, MI',
  :group => {
    :name => 'Yogurt Lovers Make Good Lovers (ew)',
    :description => random_text(100)
  }
},{
  :username => 'againstfurcoats',
  :email => 'wearinganimalsissavage@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'furcoat.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Boise, ID',
  :group => {
    :name => 'Women. In Fur Coats.',
    :description => random_text(100)
  }
},{
  :username => 'coffeebeans',
  :email => 'coffeebeans@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :is_adviser => 1,
  :avatar_file_name => 'coffeebeans.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Columbus, OH',
  :group => {
    :name => 'Fair Trade for Coffee Bean Farmers',
    :description => random_text(100)
  }
},{
  :username => 'edumacation',
  :email => 'educationforeveryone@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :is_adviser => 1,
  :avatar_file_name => 'harrypotter.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Raleigh, NC',
  :group => {
    :name => 'Edumacators of Raleigh',
    :description => random_text(100)
  }
}
]

users.each do |user|
  unless user[:person].nil?
    u = User.create!(user.except(:person))
    p = Person.create!(user[:person].merge(:user_id => u.id))
    u.person_id = p.id
    u.save
  else
    u = User.create!(user.except(:group))
    pp u.errors
    g = Group.create!(user[:group].merge(:user_id => u.id))
    u.group_id = g.id
    u.save
    f = Forum.create(:group_id => g.id, :name => g.name)
    Topic.create(:forum_id => f.id, :name => 'General Discussion')
  end

end