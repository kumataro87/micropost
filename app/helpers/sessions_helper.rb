module SessionsHelper

  # ユーザーIDを一時セッションの中に安全に置く
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログイン中のユーザーを返す
  # (目的)DBへの問い合わせに数を可能な限り小さくしたい
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ログイン中の場合true、その他ならfaiseを返す
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
