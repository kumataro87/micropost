class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,   class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
  has_many :passive_relationships,  class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
  # sourceで following 配列は followed id の集合であることを明示的に示す
    # user.following.include?(other_user)
    # user.following << other_user "追加"
    # user.following.delete(other_user) "削除"
  has_many :following, through: :active_relationships,  source: :followed
  # 外部キー <:followersの単数系>_id を自動的に探すため sourceキーは省略 
  has_many :followers, through: :passive_relationships


  attr_accessor :remember_token, :activation_token
  # before_save { self.email = email.downcase}
  # before_save 
  before_save :downcase_email
  before_create :create_activation_digest
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
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    # update_columnsはcallback, validationが実行されない
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  #有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def feed
    # 疑問符があるとidがエスケープされる
    # SQLインジェクション対策
    # SQLに変数を代入するときは常にエスケープする
    # Micropost.where("user_id = ?", self.id)

    # following_idsはhas_many :followingの関連付けをしたときにActive Recordが自動生成したもの
    # following.map(&:id)と同じ
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    
    # サブセレクトを使用する
    following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"
    Micropost.where("user_id IN  (#{following_ids})
                    OR user_id = :user_id", user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # フォローを解除する
  def unfollow(other_user)
    following.delete(other_user) if following?(other_user)
  end

  # 現在のユーザーがフォローしていたらtureを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
