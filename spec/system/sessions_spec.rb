require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#new" do
    context "無効な値の場合" do
      it "flashメッセージが表示される" do
        visit login_path
        fill_in "Email", with: "foo@bar"
        fill_in "Password", with: " "
        click_button "Log in"

        expect(page).to have_selector 'div.alert.alert-danger'
        visit help_path
        expect(page).not_to have_selector 'div.alert.alert-danger'
      end
    end

    context "有効な値の場合" do
      let!(:user) { create(:user) }

      it "ログイン状態に切り替わること" do
        visit login_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"

        expect(page).to_not have_selector "a[href=\"#{login_path}\"]"
        expect(page).to have_selector "a[href=\"#{logout_path}\"]"
        expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
      end
    end
  end
end
