require File.join(File.dirname(__FILE__),'helper')

users = [
{
  :username => 'sophia',
  :email => 'sophiachou@gmail.com',
  :password => 'password',
  :password_confirmation => 'password',
  :avatar_file_name => 'sophia.jpg',
  :avatar_content_type => 'image/jpeg',
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
  :person => {
    :full_name => 'Raindrops',
    :date_of_birth => '1950-01-02'
  }
}
]

users.each do |user|
  u = User.new(user.except(:person))
  u.save
  p = Person.new(user[:person].merge(:user_id => u.id))
  p.save
  u.person_id = p.id
  u.save
end
