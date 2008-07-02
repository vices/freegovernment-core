class Tag 
  include DataMapper::Resource

  property :id, Integer, :serial => true
  property :name, String, :nullable => false, :length => 30
  property :permalink, String, :length => 1000


  has n, :taggings


  before :create do 
    pp self.name
    self.permalink = self.name.downcase.gsub(/[^a-z0-9]+/i, '')
  end


  class << self

    def get_tags(object)
      ids = []
      tags = []
      Tagging.get_taggings(object).each do |t|
        unless ids.index(t.tag.id)
          ids << t.tag.id
          tags << t.tag
        end
      end
      return tags
    end

  end


  def get_tagged(object_type)
    klass = Kernel.const_get(object_type.capitalize)
    klass.all(:id.in => self.taggings.all(:object_type => object_type.downcase).collect { |t| t.object_id })
  end

end