require 'rails_helper'

RSpec.describe "SiteLayoutTests", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'root' do
    it 'root_pathが2つ help_path,about_pathが1つ存在すること' do
      visit root_path
      # link_to_root = page.all("a[href=\"#{root_path}\"]")
      # expect(link_to_root.size).to eq 2
      
      expect(page).to have_link  href: root_path, count: 2
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'About', href: about_path
    end
  end
end
