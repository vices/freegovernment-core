migration 1, :initial_setup do
  up do
    create_table :users do
      column :id, Integer, :serial => true
      column :username, String, :nullable => false
      column :email, String, :nullable => false
      column :salt, String
      column :crypted_password, String
      column :is_adviser, TrueClass, :default => 0
      column :person_id, Integer
      column :group_id, Integer
      column :previous_login_at, DateTime
      column :last_login_at, DateTime
      column :created_at, DateTime
      column :updated_at, DateTime
      column :address, DM::Text
      column :address_lat, Float, :scale => 9, :precision => 6
      column :address_lng, Float, :scale => 9, :precision => 6
      column :avatar_file_name, String
      column :avatar_content_type, String
      column :avatar_files_size, Integer
    end

    create_table :people do
      column :id, Integer, :serial => true
      column :full_name, String, :nullable => false, :length => 100
      column :date_of_birth, Date, :nullable => false
      column :user_id, Integer
      column :description, DM::Text
      column :political_beliefs, DM::Text
      column :interests, DM::Text
      column :created_at, DateTime
      column :updated_at, DateTime
    end

    create_table :group do
      column :id, Integer, :serial => true
      column :name, String, :nullable => false, :length => 20
      column :description, DM::Text, :nullable => false, :length => 500
      column :mission, DM::Text, :nullable => false
      column :user_id, Integer
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :users
  end
end

