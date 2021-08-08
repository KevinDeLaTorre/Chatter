module SessionsHelper

  # Logs in the given user
  def log_in( user )
    session[:user_id] = user.id
  end

  # Get current user
  def current_user
    if session[:user_id]
      # If current user nil find in db else return value of current user
      @current_user ||= User.find_by( id: session[:user_id] )
    end
  end

  def logged_in?
    !current_user.nil?
  end

end
