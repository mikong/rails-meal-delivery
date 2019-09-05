class UserSessionsController < ApplicationController
  before_action :require_logout, only: [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params.to_h)

    if @user_session.save
      redirect_to_admin_home
    else
      render 'new'
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to login_path
  end

private
  def user_session_params
    params.require(:user_session).permit(:login, :password)
  end
end
