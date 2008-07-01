class String
  
  def ellipsis(size, more_marker='...')
    if self.length > size
      self[0,size-more_marker.length]+more_marker
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
      r = RedCloth.new self
      return r.to_html
    rescue
      return self
    end
  end

end
