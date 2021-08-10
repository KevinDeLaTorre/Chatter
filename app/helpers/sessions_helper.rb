module SessionsHelper

  # Logs in the given user
  def log_in( user )
    session[:user_id] = user.id
    # Guard against session replay attacks
    session[:session_token] = user.session_token
  end

  # Logs out current user
  def log_out
    forget( current_user )
    reset_session
    @current_user = nil
  end

  # Get current user
  def current_user
    if ( user_id = session[:user_id] )
      # If current user nil find in db else return value of current user
      user ||= User.find_by( id: user_id )
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif ( user_id = cookies.encrypted[ :user_id ] )
      user = User.find_by( id: user_id )
      if user && user.authenticated?( cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the given user is the current user
  def current_user?( user )
    user && user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def remember( user )
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session
  def forget( user )
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
