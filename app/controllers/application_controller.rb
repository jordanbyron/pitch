class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :scope_current_account
  before_filter :authenticate_user!

  helper_method :current_account, :decorated_user

  private

  def current_account
    @current_account ||= Account.find_by_subdomain(request.subdomain)
  end

  def decorated_user
    @decorated_user ||= UserDecorator.decorate(current_user)
  end

  def scope_current_account
    Account.current_id = current_account.try(:id)
    yield
  ensure
    Account.current_id = nil
  end
end
