class SessionsController < ApplicationController
  include SessionsHelper
  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "ログインしました"
      redirect_to user
    else
      flash.now[:danger] = "入力されたメールアドレスとパスワードの組み合わせが見つかりません"
      render 'new'
    end
  end

  # DELTE /logout
  def destroy
    log_out
    redirect_to root_url
  end
end
