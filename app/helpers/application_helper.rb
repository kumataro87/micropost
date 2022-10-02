module ApplicationHelper

  def full_title(page_title = '')
    base_title = "Ruby on Rails"
    if page_title
      page_title + " | " + base_title
    else  
      base_title
    end
  end
end