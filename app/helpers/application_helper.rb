module ApplicationHelper
  def full_title page_title = ""
    default_title = t("default_title")
    page_title.empty? ? default_title : "#{page_title} | #{default_title}"
  end
end
