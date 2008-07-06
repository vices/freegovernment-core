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

end
