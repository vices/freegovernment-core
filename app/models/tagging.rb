class Tagging 
  include DataMapper::Resource
  property :id, Integer, :serial => true
  property :object_type, String
  property :object_id, Integer
  property :tag_id, Integer


  belongs_to :tag


  class << self

    def get_taggings(object)
      if object.class == String
        Tagging.all(:object_type => object.downcase)
      else
        object_id = object.id
        object_type = object.class.name.downcase
        Tagging.all(:object_type => object_type, :object_id => object_id)
      end
    end

    def tag_object(object, tag_list)
      if object and tag_list
        Tagging.get_taggings(object).each { |t| t.destroy! }
        
        tag_list.split(',').each do |t|
          t.strip!
          unless t.empty?
            if ( tag = Tag.first(:name => t.strip.downcase)).nil? 
              tag = Tag.create(:name => t.strip.downcase) 
            end
            Tagging.create(:object_type => object.class.name.downcase, :object_id => object.id, :tag_id => tag.id)
          end
        end
      end
    end

  end

end