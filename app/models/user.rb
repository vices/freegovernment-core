class User
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  include DataMapper::GeoKit
  include Paperclip::Resource
  
  property :id, Integer, :serial => true
  property :username, String, :nullable => false
  property :email, String, :nullable => false
  property :salt, String
  property :crypted_password, String
  property :is_adviser, Boolean, :default => 0
  property :person_id, Integer
  property :group_id, Integer
  property :previous_login_at, DateTime
  property :last_login_at, DateTime
  property :created_at, DateTime
  property :updated_at, DateTime

  has 0..1, :person
  has 0..1, :group
  
  has n, :advising_relationships
  has n, :contact_relationships
  has n, :group_relationships

  has_geographic_location :address
  
  has_attached_file :avatar,
    :styles => { :small => "60x60#", :medium => "100x100#", :large => "200x200>" },
    :default_url => "users/missing_icon_:style.png"
  
  validates_attachment_thumbnails :avatar

  validates_length :username, :within => 4..20
  validates_is_unique :username
  
  validates_format :email, :as => :email_address
  validates_length :email, :within => 3..100
  validates_is_unique :email
  
  attr_accessor :password, :password_confirmation
  
  validates_present :password, :if => proc { |r| r.new_record? }
  validates_present :password_confirmation, :if => proc { |r| r.new_record? }
  validates_length :password, :within => 8..40, :if => proc { |r| !r.password.nil? }
  validates_is_confirmed :password, :groups => :create
  
  before :save, :encrypt_password
  
  def advisee_list
    if is_adviser
      self.advising_relationships.collect{ |ar| ar.advisee_id }
    else
      {}
    end
  end
  
  def username=(value)
    attribute_set(:username, value.downcase)
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  class << self
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
    
    def authenticate(username, password)
      u = User.first(:username => username.downcase)
      u && u.authenticated?(password) ? u : nil
    end
  end
end
