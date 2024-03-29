require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#index' do
    let!(:admin) { FactoryBot.create(:user) }
    let!(:not_admin) { FactoryBot.create(:other_user) }
   
    it 'adminユーザならdeleteリンクが表示されること' do
      log_in admin
      visit users_path
  
      expect(page).to have_link 'delete'
    end
   
    it 'adminユーザでなければdeleteリンクが表示されないこと' do
      log_in not_admin
      visit users_path
  
      expect(page).to_not have_link 'delete'
    end
  end

  describe '#new #create' do
    context '無効の場合' do
      it 'エラーが描画されること' do
        visit signup_path
        fill_in 'Name', with: 'test taro'
        fill_in 'Email', with: 'test@example'
        fill_in 'Password', with: ' '
        fill_in 'Confirmation', with: ' '
        click_button 'Create my account'
        
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    context '有効の場合' do
      it 'flash[success]が表示されること' do
        visit signup_path
        fill_in 'Name', with:  'test taro'
        fill_in 'Email', with: 'test_tato@exmple.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Create my account'
        # users/:id に遷移することを確認する
        # expect(current_path).to eq "/users/#{User.last.id}"
        expect(current_path).to eq "/"
        # expect(page).to have_selector 'div.alert-success'
        expect(page).to have_selector 'div.alert-info'
      end
    end
  end
end
