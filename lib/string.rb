class String
  def render_textile
    begin
      r = RedCloth.new self
      return r.to_html
    rescue
      return self
    end
  end
end