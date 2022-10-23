require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { build(:micropost, user:user) }

  it "有効であること" do
    expect(micropost).to be_valid
  end

  it "user_idがない場合無効であること" do
    micropost.user_id = nil
    expect(micropost).to_not be_valid
  end

  it "contentは空でないこと" do
    micropost.content = "   "
    expect(micropost).to_not be_valid
  end

  it "contentは140文字以内であること" do
    micropost.content = "a" *141
    expect(micropost).to_not be_valid
  end

  it "Micropostの並び順が降順であること" do
    FactoryBot.create_list(:other_micropost, 5, user: user)
    micropost.save
    expect(micropost).to eq Micropost.first
  end

  it "userが削除された時紐づいたmicropostが消えること" do
    micropost.save
    expect{user.destroy}.to change{Micropost.count}.by(-1)
  end
end
