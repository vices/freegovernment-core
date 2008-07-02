class String
  
  def ellipsis(size, more_marker=' [...]')
    a = self.split(' ')
    if a.length > size
      a[0,size].join(' ') + more_marker
    else
      self
    end
  end

  def paragraphize
    text = self.dup
    text.replace( text.split( /\n{2,}(?! )/m ).collect do |blk|
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
