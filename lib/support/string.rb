class RedCloth
  def render_blocks
      # make our working copy
      text = self.dup

      @rules = [:refs_textile, :block_textile_table, :block_textile_lists,
                       :block_textile_prefix, :inline_textile_image, :inline_textile_link,
                       :inline_textile_code, :inline_textile_glyphs, :inline_textile_span]

      blocks text

      text.strip!
      text
  end
end

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

  def render_blocks
    begin
      r = RedCloth.new self
      return r.render_blocks
    rescue
      return self
    end
  end

end
