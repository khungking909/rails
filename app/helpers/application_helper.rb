# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def full_title(page_title = "")
    default_title = t("default_title")
    page_title.empty? ? default_title : "#{page_title} | #{default_title}"
  end
end
