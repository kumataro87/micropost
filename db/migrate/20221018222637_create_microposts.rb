class CreateMicroposts < ActiveRecord::Migration[6.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
      # user_idに関連づけられたマイクロポストを作成時間順で取り出すため
    end
    add_index :microposts, [:user_id, :create_at]
  end
end
