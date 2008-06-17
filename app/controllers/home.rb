class Home < Application
  def index
    require 'pp'
    p 'SESSION: '
    pp session
    p logged_in?
    render
  end
end
