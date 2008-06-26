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
  :password_confirmation => 'password',
  :avatar_file_name => 'raindrops.jpg',
  :avatar_content_type => 'image/jpeg',
  :address_text => 'Boca Raton, FL',
  :person => {
    :full_name => 'Raindrops',
    :date_of_birth => '1950-01-02'
  }
}
]

users.each do |user|
  u = User.create!(user.except(:person))
  p = Person.create!(user[:person].merge(:user_id => u.id))
  u.person_id = p.id
  u.save
end
