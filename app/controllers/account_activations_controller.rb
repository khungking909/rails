class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit
  before_action :user_activation, only: :edit

  def edit
    @user.activate
    log_in(@user)
    flash[:success] = t("succes_singup")
    redirect_to(@user)
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t("not_found_users")
    redirect_to(signup_path)
  end

  def user_activation
    return if !@user.activated && @user.authenticated?(:activation, params[:id])

    flash[:danger] = t("invalid_activation_link")
    redirect_to(signup_path)
  end
end
