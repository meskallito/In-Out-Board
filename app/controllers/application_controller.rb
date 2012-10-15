class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActionController::RoutingError, with: :authorize

  private

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      reset_session
      authorize
    end
  end
  helper_method :current_user

  def authorize
    redirect_to login_url if current_user.nil?
  end

  def login_user(user)
    user.working!
    send_status_update(user)
    session[:user_id] = user.id
  end

  def logout_user
    current_user.not_working!
    send_status_update(current_user)
    reset_session
  end

  def send_status_update(user)
    PrivatePub.publish_to("/users/update", render_to_string("users/update", formats: :js,  locals: { :@user => user } ) )
  end

end
