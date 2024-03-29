class ApplicationController < ActionController::Base
  include SessionsHelper

private
    # ログイン済みのユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_path
      end
    end
end