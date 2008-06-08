module UserSpecHelper
  def valid_new_user 
    {
      :username => 'Foysavas',
      :email => 'foysavas@gmail.com',
      :password => 'password',
      :password_confirmation => 'password'
    }
  end
end
