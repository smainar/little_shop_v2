class SessionsController < ApplicationController
  def new
  end
  def create
    binding.pry
    user = User.find_by(email: params[:email])
    if user && user.password_digest == params[:password]
      session[:user_id] = user.id
      # current_user
      redirect_to profile_path
    else
      flash[:login_failed] = "Login Failed!"
      render :new
    end
  end
end
