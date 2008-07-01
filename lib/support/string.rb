class String
  def ellipsis(size, more_marker='...')
    if self.length > size
      self[0,size-more_marker.length]+more_marker
    else
      self
    end
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
