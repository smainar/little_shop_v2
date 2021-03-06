class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if !user.active
        flash[:error] = "Your account has been disabled."
        render :new
        return
      end
      session[:user_id] = user.id
      flash[:welcome] = "Welcome, #{user.name}!"
      if current_user.admin?
        redirect_to root_path
      elsif current_user.merchant?
        redirect_to merchant_dashboard_path
      else
        redirect_to profile_path
      end
    else
      flash[:error] = "Incorrect Username/Password Combination"
      render :new
    end
  end

  def destroy
    reset_session
    flash[:message] = "You are logged out!"
    redirect_to root_path
  end
end
