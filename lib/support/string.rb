require 'rexml/parsers/pullparser'

class String
  
  def ellipsis(size, more_marker='...')
    if self.length > size
      if (a = self[0..size].split(' ')).length > 1
        a[0..-2].join(' ') + more_marker
      else
        self[0..size] + more_marker
      end
    else
      self
    end
  end

  def paragraphize
    text = self.dup
    text.replace( text.split( /\n{1,}(?! )/m ).collect do |blk|
      blk.strip!
      if blk.empty?
        blk
      else
        blk = "<p>#{ blk }</p>"
      end
    end.join( "\n\n" ) )
  end

  def render_textile
    begin
      r = RedCloth.new(self, [:filter_html])
      return r.to_html
    rescue
      return self
    end
  end

  def truncate_html(len = 30)
    p = REXML::Parsers::PullParser.new(self)
    tags = []
    new_len = len
    results = ''
    while p.has_next? && new_len > 0
      p_e = p.pull
      case p_e.event_type
      when :start_element
        tags.push p_e[0]
        results << "<#{tags.last} #{attrs_to_s(p_e[1])}>"
      when :end_element
        results << "</#{tags.pop}>"
      when :text
        results << p_e[0][0,new_len]
        new_len -= p_e[0].length
      else
        results << "<!– #{p_e.inspect} –>"
      end
    end
    tags.reverse.each do |tag|
      results << "</#{tag}>"
    end
    results
  end

  private

  def attrs_to_s(attrs)
    if attrs.empty?
      ''
    else
      attrs.to_a.map { |attr| %{#{attr[0]}="#{attr[1]}"} }.join(' ')
    end
  end

end
