class Home < Application
  before Proc.new{ @nav_active = :home }

  def index
    render
  end
end
