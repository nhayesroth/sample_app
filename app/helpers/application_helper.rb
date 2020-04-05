module ApplicationHelper
  BASE_TITLE = "Ruby on Rails Tutorial Sample App"
  
  # Returns an html page title, optionally adding a page-specific prefix
  def full_title(page_title = "")
    page_title.empty? ?
      BASE_TITLE :
      "#{page_title} | #{BASE_TITLE}"
  end
  
end
