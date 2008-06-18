class Bills < Application
  before Proc.new{ @nav_active = :bills }
  
  def index
    render
  end
end