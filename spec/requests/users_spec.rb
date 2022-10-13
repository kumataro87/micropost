require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }

    it "returns http success" do
      get users_path
      expect(response).to redirect_to login_path
    end

    describe 'pagenation' do
      before do
        30.times { create(:continuous_users)}
        log_in user
        get users_path
      end

      context "ログインしている場合" do
        it "ユーザーごとのリンクが存在すること" do
          User.paginate(page: 1).each do |user|
            expect(response.body).to include "<a href=\"#{user_path(user)}\">"
          end
        end

        it 'div.paginationが存在すること' do
          expect(response.body).to include 'class="pagination"'
        end
      end
    end
  end
  describe "GET /signup" do
    it "returns http success" do
      # get "/signup"
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "POST /users" do
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
      let(:user_params) { { user: { name: 'test taro',
                                      email: 'test@example.com',
                                      password: 'password',
                                      password_confirmation: 'password' } } }
      
      it '登録されること' do
        expect{ 
          post users_path, params: user_params
        }.to change(User, :count).by(1)
      end

      it 'ログイン状態になること' do
        post users_path, params: user_params
        # be_truthyは真、be_falsey
        expect(logged_in?).to be_truthy
      end
    end
  end

  describe "GET /users/:id/edit" do
    let!(:user) { create(:user) }

    context "ログインしていない場合" do
      it "flashが表示されること" do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end

      it "ログインページにリダイレクトされること" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context "別のユーザーの場合" do
      let!(:other_user) { create(:user) }

      # it "flashが表示されること" do
      #   log_in user
      #   get edit_user_path(other_user)
      #   expect(flash).to be_empty
      # end

      it "root_urlにリダイレクトされること" do
        log_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_url
      end
    end

    context "未ログインの場合" do
      it "ログインページに遷移し、ログイン後に編集画面に戻ること" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end
  end

  describe "PATCH /users" do
    let(:user) { create(:user)}
    
    context "有効の場合" do

      before do
        log_in user
        @name = "taro"
        @email = "taro@example.com"
        patch user_path(user), params: { user: { name: @name,
                                                 email: @email,
                                                 password: "",
                                                 password_confirmation: ""}}
      end

      it "更新に成功すること" do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it "users #showにリダイレクトすること" do
        expect(response).to redirect_to user
      end

      it "flashが表示されること" do
        expect(flash).to be_any
      end
    end

    context "無効の場合" do

      before do
        log_in user
        patch user_path(user), params: { user: { name: "",
                                                 email: "",
                                                 password: "pass",
                                                 password_confirmation: "word"}}
      end

      it "更新に失敗すること" do
          user.reload
          expect(user)
          expect(user.name).to_not eq ""
          expect(user.email).to_not eq ""
          expect(user.password).to_not eq "pass"
          expect(user.password_confirmation).to_not eq "word"
      end
        
      it "editページに遷移すること" do
        # expect(response.body).to include 'alert-danger'
        expect(response.body).to include 'The form contains 5 errors.'
      end
    end

    context "ログインしていない場合" do
      before do
        patch user_path(user), params: { session: { email: user.email,
                                                    password: user.password }}
      end

      it "flashが表示されること" do
        expect(flash).to_not be_empty
      end

      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to login_path
      end
    end

    # context "別のユーザーの場合" do
    #   let!(:other_user) { create(:user) }
    #   before do
    #     log_in user
    #     patch user_path(other_user), params: { user: { name:  user.name,
    #                                                    email: user.email }}
    #   end

    #   it "flashがからであること" do
    #     expect(flash).to be_empty
    #   end

    #   it "root_urlにリダイレクトされること" do
    #     expect(response).to respond_to root_url
    #   end
    # end
  end
end
