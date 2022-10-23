require 'rails_helper'
 
RSpec.describe "MicroPosts", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe 'Users#show' do
    before do
      create_list(:other_micropost, 35, user: create(:user) )
      @user = Micropost.first.user
    end
 
    it '30件表示されていること' do
      visit user_path @user
 
      posts_wrapper =
        within 'ol.microposts' do # withinはスコープを指定するCapybaraのメソッド
          find_all('li')
        end
      expect(posts_wrapper.size).to eq 30
    end
 
    it 'ページネーションのラッパータグが表示されていること' do
      visit user_path @user
      expect(page).to have_selector 'div.pagination'
    end
 
    it 'Micropostの本文がページ内に表示されていること' do
      visit user_path @user
      @user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
    
    it 'ページネーションの表示が1箇所のみであること' do
      visit user_path @user
      pagination = find_all('div.pagination')
      expect(pagination.size).to eq 1
    end

    context "他のユーザーの場合" do
      it "Postのdeleteボタンが表示されないこと" do
        other_user = create(:other_user)
        other_user.microposts.create(content: "Hello world")
        log_in @user
        visit user_path other_user
        expect(page).to_not have_link 'delete'
        expect(page).to have_content 'Hello world'
      end
    end
  end

  describe 'home' do
    before do
      create_list(:other_micropost, 35, user: create(:user) )
      @user = Micropost.first.user
      @user.password = "password"
      log_in @user
      #     root_urlだとfailする
      visit root_path
    end

    it 'ページネーションのラッパータグがあること' do
      expect(page).to have_selector 'div.pagination'
    end

    it "削除できること" do
      fill_in "micropost_content", with: "learning the program" 
      click_button '投稿する'

      # before actionでソートしている為firstで最新データを取得
      post = Micropost.first

      expect{
        click_link 'delete', href: micropost_path(post)
      }.to change(Micropost, :count).by(-1)
      expect(page).to_not have_content "learning the program"
    end

    context '有効な送信の場合' do
      it '投稿されること' do
        expect{
          fill_in "micropost_content", with: "learning the program"
          click_button '投稿する'
        }.to change(Micropost, :count).by(1)
        
        expect(page).to have_content "learning the program"
      end
    end
    
    context '無効な送信の場合' do
      it "投稿されないこと" do
        expect{
          fill_in "micropost_content", with: "  "
          click_button '投稿する'
        }.to_not change(Micropost, :count)
        expect(page).to have_selector 'div.alert-danger'
        expect(page).to have_link '2', href: '/?page=2'
      end
    end
  end
end