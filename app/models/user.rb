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
  property :address_text, DM::Text
  property :street_address1, String 
  property :street_address2, String 
  property :city_town, String
  property :zipcode, String
  property :state, String
  property :private_votes, Boolean, :default => 0
  property :private_profile, Boolean, :default => 0

  has 0..1, :person
  has 0..1, :group
  
  has n, :adviser_relationships, :child_key => [:adviser_id]
  has n, :contact_relationships
  has n, :group_relationships

  has_geographic_location :address
  
  has_attached_file :avatar,
    :styles => { :small => "60x60#", :medium => "100x100>", :large => "200x200>" },
    :default_url => "users/missing_icon_:style.png",
    :whiny_thumbnails => true
  
  validates_attachment_thumbnails :avatar

  validates_length :username, :within => 4..32
  validates_is_unique :username
  validates_format :username, :with => /^([0-9a-z_]+)$/i

  validates_format :email, :as => :email_address
  validates_length :email, :within => 3..100
  validates_is_unique :email
  
  validates_length :address_text, :within => 0..150
  validates_length :street_address1, :within => 0..50 
  validates_length :street_address2, :within => 0..50
  validates_length :city_town, :within => 0..50
  validates_length :state, :within => 0..30 
  validates_length :zipcode, :within => 0..10
 
  attr_accessor :password, :password_confirmation
  
  validates_present :password, :if => proc { |r| r.new_record? }
  validates_present :password_confirmation, :if => proc { |r| r.new_record? }
  validates_length :password, :within => 8..40, :if => proc { |r| !r.password.nil? }
  validates_is_confirmed :password, :groups => :create
  
  before :save, :encrypt_password
  
  def address_text=(value)
    attribute_set(:address_text, value)
    self.address = value
  end

  def street_address1=(value)
    attribute_set(:street_address1, value)
    self.address = "#{self.street_address1}, #{self.street_address2}, #{self.city_town}, #{self.zipcode}" 
   pp self.address  
end

  def street_address2=(value)
    attribute_set(:street_address2, value)
    self.address = "#{self.street_address1}, #{self.street_address2}, #{self.city_town}, #{self.zipcode}" 
  end

  def city_town=(value)
    attribute_set(:city_town, value)
    self.address = "#{self.street_address1}, #{self.street_address2}, #{self.city_town}, #{self.zipcode}" 
  end

  def zipcode=(value)
    attribute_set(:zipcode, value)
    self.address = "#{self.street_address1}, #{self.street_address2}, #{self.city_town}, #{self.zipcode}" 
  end
  
  def address_set=(item, value)
    @item = item.to_s  
    attribute_set(@item, value)
    self.address = "#{self.street_address1}, #{self.street_address2}, #{self.city_town}, #{self.zipcode}" 
  end
 
  def advisees
    AdviserRelationship.all(:adviser_id => self.id, :order => [:modified_at.desc]).collect{|ar| ar.person}
  end

  def advisee_list
    if self.is_adviser
      AdviserRelationship.all(:adviser_id => self.id).collect{ |ar| ar.person.user_id }
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
