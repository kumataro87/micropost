require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let! (:micropost) { create(:micropost) }

  describe "POST /micropost" do
    context "未ログインの場合" do
      it "リダイレクトすること" do
        delete micropost_path micropost
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE /micropost/:id" do
    let(:other_user) { create(:other_user)}

    context "未ログインの場合" do
      it "リダイレクトすること" do
        delete micropost_path micropost 
        expect(response).to redirect_to login_path
      end
    end

    context "ユーザーが正しくない場合" do
      before do
        log_in other_user
      end

      it "削除されないこと" do
        
        expect{ delete micropost_path(micropost)}.to_not change(Micropost, :count)
      end

      it "リダイレクトすること" do
        get root_url
        delete micropost_path micropost
        expect(response).to redirect_to root_url
      end
    end
  end
end
