require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "POST /relationships" do
    let(:user){ create(:user) }
    let(:other_user){ create(:other_user) }

    context "ログインしていない場合" do
      it "ログインページにリダイレクトする" do
          expect{ post relationships_path, 
                  params: { followed_id: other_user.id }
                }.to_not change{ user.following.size }
          expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE /relationships/:id" do
    let(:user){ create(:user) }
    let(:other_user){ create(:other_user) }
    
    before do
      user.following << other_user
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトする" do
          expect{ 
            delete relationship_path(other_user)
          }.to_not change{ user.following.size }
          expect(response).to redirect_to login_path
      end
    end
  end
end