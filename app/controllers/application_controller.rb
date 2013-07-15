class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  helper_method :current_account, :decorated_user

  private

  def current_account
    Account.where(database_name: Apartment::Database.current).first
  end

  def decorated_user
    @decorated_user ||= UserDecorator.decorate(current_user)
  end
end
