class SessionsController < ApplicationController
  skip_before_action :redirect_if_not_logged_in, only: [:omniauth, :new, :create]

  def omniauth
    @user = User.from_oauth(auth)
    if @user.valid?
      session[:user_id] = @user.id
      redirect_to user_workouts_path(@user)
    else  
      redirect_to new_session_path, alert: "Something went wrong."
    end
  end

  def new
    redirect_to user_workouts_path(current_user) if logged_in?
  end

  def create
    if @user = User.find_by_email(params[:email])&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to user_workouts_path(@user)
    else
      redirect_to new_session_path, alert: "The password and/or email are incorrect"
    end
  end

  def destroy
    reset_session
    redirect_to '/'
  end

  private
  def auth
    request.env['omniauth.auth']
  end

end
