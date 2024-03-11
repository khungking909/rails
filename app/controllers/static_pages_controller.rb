# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: :home

  def home
    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy(current_user.feed, items: Settings.page_5)
  end

  def help; end
end
