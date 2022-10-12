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
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "ログインしました"
      redirect_back_or user
    else
      flash.now[:danger] = "入力されたメールアドレスとパスワードの組み合わせが見つかりません"
      render 'new'
    end
  end

  # DELTE /logout
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
