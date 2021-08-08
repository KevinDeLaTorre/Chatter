class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by( email: params[:session][:email].downcase)
    if user && user.authenticate( params[:session][:password] )
      reset_session
      log_in user
      redirect_to user
    else
      # Display error message and redirect back to log in
      flash.now[:danger] = 'Invalid email/password'
      render 'new'
    end
  end

  def destroy
  end
end
