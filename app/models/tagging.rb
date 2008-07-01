class Tagging 
  include DataMapper::Resource
  property :id, Integer, :serial => true
  property :object_type, String
  property :object_id, Integer
  property :tag_id, Integer

  belongs_to :tag

  class << self
    def get_all_taggings(object_type)
      Tagging.all(:object_type => object_type.downcase)
    end
  end

end