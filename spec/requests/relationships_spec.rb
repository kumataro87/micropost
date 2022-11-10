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

    context "ログインしている場合" do
      before do
        log_in user
      end

      it "ユーザーをフォローできること" do
        expect{ post relationships_path,
                params: { followed_id: other_user.id}
        }.to change(Relationship, :count).by(1)
        expect(response).to redirect_to other_user
      end

      it "ユーザーをフォローできること(xhr)" do
        expect{ post relationships_path,
                xhr: true, params: { followed_id: other_user.id}
        }.to change(Relationship, :count).by(1)
      end
    end
  end

  describe "DELETE /relationships/:id" do
    let!(:user){ create(:user, :user_with_followed) }
    let!(:other_user){ user.following.last }
    # user.following << other_user rspecでもメソッド使用可

    context "ログインしていない場合" do
      it "ログインページにリダイレクトする" do
          expect{ 
            delete relationship_path(other_user)
          }.to_not change(Relationship, :count)
          expect(response).to redirect_to login_path
      end
    end
    
    context "ログインしている場合" do
      before do
        log_in user
      end

      it "アンフォローできること" do
        relation = user.active_relationships.find_by(followed_id: other_user.id)
        expect{
          delete relationship_path(relation)
        }.to change(Relationship, :count).by(-1)
        expect(response).to redirect_to other_user
      end

      it "アンフォローできること(xhr)" do
        relation = user.active_relationships.find_by(followed_id: other_user.id)
        expect{
          delete relationship_path(relation),
          xhr: true
        }.to change(Relationship, :count).by(-1)
      end
    end
  end
end