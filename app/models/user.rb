class User
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :username, String, :nullable => false
  property :email, String, :nullable => false
  property :salt, String, :nullable => false
  property :crypted_password, String, :nullable => false
  
  attr_accessor :password, :password_confirmation
  
  validates_present :password
  validates_present :password_confirmation
  validates_is_unique :username, :email
end