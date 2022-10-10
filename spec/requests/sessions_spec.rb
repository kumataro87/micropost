require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    let(:user) { create(:user) }

    context 'remember_meが1の場合' do
      it 'cookies[:remember_token]が空でないこと' do
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
                                              remember_me: '1' } }
        expect(cookies[:remember_token]).to_not be_blank
      end
    end

    context 'remember_meが0の場合' do
      it 'cookies[:remember_token]が空であること' do
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
                                              remember_me: '0' } }
        expect(cookies[:remember_token]).to be_blank
      end
    end
  end

  describe "DELETE /logout" do
    before do
      user = create(:user)
      post login_path params: { session: {
                                email: user.email, password: user.password } }
    end

    it "ログアウトできること" do
      expect(logged_in?).to be_truthy
      delete logout_path
      expect(logged_in?).not_to be_truthy  
    end

    it "2回連続でログアウトできること" do
      delete logout_path
      delete logout_path
      expect(response).to redirect_to root_url
    end
  end
end
