class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if current_account && !user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
