class Micropost < ApplicationRecord
  belongs_to :user
  # データベースから要素を取り出すとき降順にする
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: {maximum: 140 }
  validates :user_id, presence: true
end
