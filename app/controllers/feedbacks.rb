class Feedbacks < Application

  def create
    @feedback = Feedback.new(params[:feedback].merge(:user_id => session[:user_id]))
    if @feedback.save
      return 'ok'
    end
  end

end
