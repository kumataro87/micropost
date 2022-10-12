module SessionsHelper

  # ユーザーIDを一時セッションの中に安全に置く
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続化する
  def remember(user)
    user.remember # Userのインスタンスメソッド
    cookies.permanent.encrypted[:user_id] = user.id # "signed"ユーザーidを暗号化する
    cookies.permanent[:remember_token] = user.remember_token
  end

  # ログイン中のユーザーを返す
  # (目的)DBへの問い合わせに数を可能な限り小さくしたい
  def current_user
    # if session[:user_id]
    #   @current_user ||= User.find_by(id: session[:user_id])
    # end
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif(user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ログイン中の場合true、その他ならfaiseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def correct_user?(user)
    user && user == current_user
  end

  # フレンドリーフォワーディング(pop)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # フレンドリーフォワーディング(push)
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
