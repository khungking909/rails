# frozen_string_literal: true

module UsersHelper
  def gravatar_for(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = Settings.size_80
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def destroy_user?(user)
    current_user.admin? && !current_user?(user)
  end

  def user_relation?(user)
    current_user.following.find_by(id: user.id).present?
  end
end
