class BillSection
  include DataMapper::Resource
  include DataMapper::Timestamp

  property :id, Integer, :serial => true
  property :bill_id, Integer, :nullable => false
  property :forum_id, Integer, :nullable => false
  property :topic_id, Integer
  property :title, DM::Text, :nullable => false
  property :text, DM::Text

  class << self
    def section_text(bill)
      #text_split = self.text.split(/((?:SECTION|SEC\.) (?:[ 0-9]+)\. (?:[A-Z ',;\-0-9\n]+)\.\n)/) 
      text_split = bill.text.split(/((?:SECTION|SEC\.) (?:[ 0-9]+)\.(?:[A-Z ',;\-0-9\.]+|)\n)/) 
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
      pp bill
      pp sections
      sections.each do |section|
        BillSection.create({:title => section[0], :text => section[1], :forum_id => bill.forum_id, :bill_id => bill.id})
      end
    end
  end

end
