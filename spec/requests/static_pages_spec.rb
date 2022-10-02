require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

  let(:base_title) {'Ruby on Rails'}

  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "Home | #{base_title}"
    end
  end
  
  describe "GET /help" do
    it "returns http success" do
      get help_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "Help | #{base_title}"
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "About | #{base_title}"
    end
  end
end
