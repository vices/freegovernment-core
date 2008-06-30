class Bills < Application
  before Proc.new{ @nav_active = :bills }
  
  def index
    render
  end

  def new
    render
  end

  def create
    
  end

  def show
    render
  end
end
