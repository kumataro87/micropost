require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      # get "/signup"
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users #create" do
    context "無効な値の場合" do
      it "登録されないこと" do
        # expect(...) カッコ内を先に処理しexpectに渡す
        # expect{...} ブロック内部はその場で処理されず、expectに渡す
        expect{
          post users_path, params: { user: { name: ' ',
                                            email: ' ',
                                            password: 'password',
                                            password_confirmation: 'foobar'}}
        }.to_not change(User, :count)
      end
    end
    
    context "有効な値の場合" do
      it '有効な値が登録されること' do
        expect{ 
          post users_path, params: { user: { name: 'test taro',
                                             email: 'test@example.com',
                                             password: 'password',
                                             password_confirmation: 'password' }}
          }.to change(User, :count).by(1)
        end
      end
    end
end
