require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build :user }
  let(:other_user){ create(:other_user)}

  it 'userが有効であること' do
    expect(user).to be_valid
  end

  it 'nameが存在すること' do
    user.name = ""
    expect(user).to_not be_valid
  end
  
  it 'nameが50字以内であること' do 
    user.name = "a" * 51
    expect(user).to_not be_valid
  end

  it 'emailが存在すること' do
    user.email = ""
    expect(user).to_not be_valid
  end

  it 'emailが255字以内であること' do
    user.email = ("a" * 244) + "@example.com"
    expect(user).to_not be_valid
  end

  it 'emailが不正でない時、保存できること' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end  
  end

  it 'emailが不正な時、保存できないこと' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to_not be_valid
    end  
  end

  it 'emailがユニークであること' do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to_not be_valid
  end

  it 'emailは小文字でDBに保存されること' do
    mixed_case_email = "HoGEHoge@exAmplae.com"
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq mixed_case_email.downcase
  end

  # it 'user作成にpassword_cofirmationがnilでないこと' do
  #   user.password_confirmation = nil
  #   expect(user).to_not be_valid
  # end

  it 'password should be present' do
    user.password = user.password_confirmation = " " * 6
    expect(user).to_not be_valid
  end

  it 'password should have a minimum length' do
    user.password = user.password_confirmation = "a" * 5
    expect(user).to_not be_valid
  end

  describe '#authenticated?' do
    it 'digestがnilの時、falseが返ること' do
      expect(user.authenticated?(:remember, '')).to be_falsy
    end
  end

  describe "relationship" do
    it "ユーザーをフォローできること" do
      expect(user.following?(other_user)).to_not be_truthy
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
    end
    
    it "ユーザーをアンフォローできること" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).to_not be_truthy    
    end
    
    it "ユーザーをフォローしたとき、相手のフォロワーに追加されること" do
      expect(other_user.followers.include?(user)).to_not be_truthy 
      # user.follow(other_user)
      other_user.followers << user
      expect(other_user.followers.include?(user)).to be_truthy 
    end
  end
    
  describe "feed" do
    let!(:user) { create(:user)}
    let(:followed_user ){ create(:other_user) }
    let(:no_followed_user){ create(:other_user)}

    before do
      user.microposts.create(content: "self micropost")
      followed_user.microposts.create(content: "followed post")
      no_followed_user.microposts.create(content: "no followed post")
      user.following << followed_user
    end

    it "自身のmicropostが含まれること" do
      user.microposts.each do |post_self|
        expect(user.feed.include?(post_self)).to be_truthy
      end
    end

    it "フォローユーザーのmicropostが含まれれること" do
      followed_user.microposts.each do |post_following|
        expect(user.feed.include?(post_following)).to be_truthy
      end
    end

    it "フォローしていないユーザーは表示されないこと" do
      no_followed_user.microposts.each do |post_unfollowed|
        expect(user.feed.include?(post_unfollowed)).to_not be_truthy
      end
    end
  end
end
  