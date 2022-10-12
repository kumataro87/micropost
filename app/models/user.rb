class User < ApplicationRecord
  attr_accessor :remember_token
  # before_save { self.email = email.downcase}
  before_save { email.downcase! }
  # text型には文字の最大値を設けること
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50 }
  validates :email, presence: true, length: {maximum: 255 },
             format: { with: VALID_EMAIL_REGEX},
             uniqueness: { case_sensitive: false}
             # 大文字小文字を区別しない
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password

  # 渡された文字列のハッシュを返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 記憶トークンをハッシュ化してDBに保存する
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token)) 
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
