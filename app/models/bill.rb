class Bill
  include DataMapper::Resource
  include DataMapper::Timestamp
  include DataMapper::Validate

  property :id, Integer, :serial => true
  property :title, String, :length => 1000
  property :summary, DM::Text
  property :text, DM::Text, :nullable => false
  property :sectioned_text, DM::Text, :nullable => false
  property :user_id, Integer, :nullable => false
  property :poll_id, Integer, :nullable => false

  def text=(value)
    attribute_set(:text, value)
    attribute_set(:sectioned_text, section_text.to_yaml)
  end

  def sectioned_text
    if(value = attribute_get(:sectioned_text)).nil?
      nil
    else
      ::YAML.load(value)
    end
  end

  private

  def section_text
    #text_split = self.text.split(/((?:SECTION|SEC\.) (?:[ 0-9]+)\. (?:[A-Z ',;\-0-9\n]+)\.\n)/) 
    text_split = self.text.split(/((?:SECTION|SEC\.) (?:[ 0-9]+)\.(?:[A-Z ',;\-0-9\.]+|)\n)/)  
    sections = []
    section_num = -1
    text_split.each do |part|
      if part =~ /^(?:SECTION|SEC\.)/
        section_num = section_num + 1
        sections[section_num] = []
        sections[section_num][0] = part.chomp!
      else
        if section_num > -1
          unless sections[section_num].nil?
            if sections[section_num][1].nil?
              sections[section_num][1] = part
            else
              sections[section_num][1] = sections[section_num][1] + part
            end
          end
        end
      end
    end
    sections
  end


end
