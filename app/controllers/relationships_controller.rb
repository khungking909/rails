class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    if !user_relation?(@user)
      current_user.follow(@user)
      respond_to do |format|
        format.html {redirect_to @user}
        format.turbo_stream
      end
    else
      flash[:danger] = t("not_found_users")
      redirect_to(home_page_path)
    end
  end

  def destroy
    @user = @relationship.followed
    if user_relation?(@user)
      current_user.unfollow(@user)
      respond_to do |format|
        format.html {redirect_to @user}
        format.turbo_stream
      end
    else
      flash[:danger] = t("not_found_users")
      redirect_to(home_page_path)
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t("not_found_users")
    redirect_to(home_page_path)
  end

  def load_relationship
    @relationship = Relationship.find_by id:params[:id]
    return if @relationship

    flash[:danger] = t("relationship.not_follow")
    redirect_to(home_page_path)
  end
end
