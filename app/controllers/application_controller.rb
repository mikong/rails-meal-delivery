# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user, :logged_in?

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)

    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = current_user_session&.user
  end

  def require_login
    return if current_user

    flash[:notice] = t('login.required')
    redirect_to login_path
  end

  def require_logout
    return unless current_user

    flash[:notice] = t('logout.required')
    redirect_to_admin_home
  end

  def logged_in?
    current_user.present?
  end

  def redirect_to_admin_home
    redirect_to root_path
  end
end
