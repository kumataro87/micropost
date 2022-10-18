require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "GET /account_activations/:id/edit" do
    before do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
      # コントローラーで使用しているインスタンス変数を取得
      @user = controller.instance_variable_get('@user')
    end

    context "トークンとemailが有効な場合" do
      it "activated属性がtrueになること" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        @user.reload
        expect(@user).to be_activated
      end

      it "ログイン状態になること" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(logged_in?).to be_truthy
      end

      it "users/:idにリダイレクトすること" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(response).to redirect_to @user
      end
    end

    context "トークン||emailが無効な場合" do
      it "有効化トークンが不正ならログイン状態にならないこと" do
        get edit_account_activation_path('foobar', email: @user.email)
        expect(logged_in?).to_not be_truthy
      end
      
      it "emailが不正ならログイン状態にならないこと" do
        get edit_account_activation_path(@user.activation_token, email: "foobar@example.com")
        expect(logged_in?).to_not be_truthy
      end
    end
  end
end
