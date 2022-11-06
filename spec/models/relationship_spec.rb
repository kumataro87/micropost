require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:other_user){ create(:other_user)}

  before do
    @relationship = user.active_relationships.build(followed_id: other_user.id)
  end

  it "有効であること" do
    expect(@relationship).to be_valid
  end

  it "follower_idが必要であること" do
    @relationship.followed_id = nil
    expect(@relationship).to_not be_valid
  end

  it "followed_idが必要であること" do
    @relationship.followed_id = nil
    expect(@relationship).to_not be_valid
  end
end
