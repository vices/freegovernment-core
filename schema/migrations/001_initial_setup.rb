migration 1, :initial_setup do
  # user person group poll advising_relationship, contact_relationship
  # group_relationship, forum, vote, post, topic
  
  
  
  up do
    create_table :contact_relationships do
      column :id, Integer, :serial => true
      column :adviser_id, Integer, :nullable => false
      column :advisee_id, Integer, :nullable => false
      column :created_at, DateTime
      column :modified_at, DateTime
    end
    
    create_table :advising_relationships do
      column :id, Integer, :serial => true
      column :adviser_id, Integer, :nullable => false
      column :advisee_id, Integer, :nullable => false
      column :created_at, DateTime
      column :modified_at, DateTime
    end
    
    create_table :group_relationships do
      column :id, Integer, :serial => true
      column :user_id, Integer, :nullable => false
      column :group_id, Integer, :nullable => false
      column :is_accepted, TrueClass, :default => 1, :nullable => false
      
      column :created_at, DateTime
      column :modified_at, DateTime  
    end
    
    create_table :forums do
      column :id, Integer, :serial => true
      column :name, String, :nullable => false
      column :posts_count, Integer, :default => 0
      column :topics_count, Integer, :default => 0
      column :group_id, Integer,  :nullable? => true
      column :poll_id, Integer,  :nullable? => true
      column :created_at, DateTime
      column :updated_at, DateTime
    end
    
    create_table :users do
      column :id, Integer, :serial => true
      column :username, String, :nullable => false
      column :email, String, :nullable => false
      column :salt, String
      column :crypted_password, String
      column :is_adviser, TrueClass, :default => 0
      column :person_id, Integer, :nullable? => true
      column :group_id, Integer, :nullable? => true
      column :previous_login_at, DateTime
      column :last_login_at, DateTime
      column :created_at, DateTime
      column :updated_at, DateTime
      column :address, DM::Text
      column :address_lat, Float, :scale => 9, :precision => 6
      column :address_lng, Float, :scale => 9, :precision => 6
      column :avatar_file_name, String, :nullable? => true
      column :avatar_content_type, String, :nullable? => true
      column :avatar_file_size, Integer, :nullable? => true
    end

    create_table :people do
      column :id, Integer, :serial => true
      column :full_name, String, :nullable => false, :length => 100
      column :date_of_birth, Date, :nullable => false
      column :user_id, Integer, :nullable? => true
      column :description, DM::Text
      column :political_beliefs, DM::Text
      column :interests, DM::Text
      column :created_at, DateTime
      column :updated_at, DateTime
    end
    
    create_table :polls do
      column :id, Integer, :serial => true
      column :user_id, Integer, :nullable => false
      column :forum_id, Integer, :nullable? => true
      column :yes_count, Integer, :default => 0, 
      column :no_count, Integer, :default => 0, 
     	column :vote_count, Integer, :default => 0, 
      column :verified_yes_count, Integer, :default => 0, 
      column :verified_no_count, Integer, :default => 0, 
      column :verified_vote_count, Integer, :default => 0, 
      column :question, String, :nullable => false, :length => 140
      column :description, DM::Text
      column :created_at, DateTime
      column :updated_at, DateTime
    end
    
    create_table :posts do
      column :id, Integer, :serial => true
      column :text, DM::Text, :nullable => false, :length => 10000
      column :user_id, Integer, :nullable => false
      column :topic_id, Integer, :nullable => false
      column :parent_id, Integer, :nullable => false
      column :forum_id, Integer, :nullable => false
      column :created_at, DateTime
      column :updated_at, DateTime      
    end
    
    create_table :groups do
      column :id, Integer, :serial => true
      column :name, String, :nullable => false, :length => 20
      column :description, DM::Text, :nullable => false, :length => 500
      column :mission, DM::Text, :nullable => false
      column :user_id, Integer, :nullable? => true
      column :created_at, DateTime
      column :updated_at, DateTime
    end
    
    create_table :topics do
      column :id, Integer, :serial => true
      column :name, String, :nullable => false, :length => 140
      column :forum_id, Integer, :nullable => false
      column :user_id, Integer, :nullable => false
      column :group_id, Integer, :nullable? => true
      column :poll_id, Integer, :nullable? => true
      column :created_at, DateTime
      column :updated_at, DateTime

    end
    
    create_table :votes do
      column :id, Integer, :serial => true
      column :poll_id, Integer, :nullable => false
      column :user_id, Integer, :nullable => false
      column :is_yes, TrueClass, :default => 0, :nullable => false, 
      column :is_no, TrueClass, :default => 0, :nullable => false, 
      column :is_adviser_decided, TrueClass, :default => 0, :nullable => false,  
      column :adviser_yes_count, Integer, :default => 0, 
      column :adviser_no_count, Integer, :default => 0, 
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  # user person group poll advising_relationship, contact_relationship
  # group_relationship, forum, vote, post, topic

  down do
    drop_table :users
    drop_table :people
    drop_table :polls
    drop_table :advising_relationships
    drop_table :contact_relationships
    drop_table :group_relationships
    drop_table :forums
    drop_table :votes
    drop_table :posts
    drop_table :topics    
  end
end

