class PasswordResetsController < ApplicationController
  before_action :load_user, :check_user_actived, only: %i(edit create update)
  before_action :valid_user, :check_expiration, only: %i(edit update)
  before_action :check_password_presence, only: :update

  def new; end

  def edit; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t("password_reset.send_mail")
    redirect_to(login_path)
  end

  def update
    if @user.update(user_params.merge(reset_digest: nil))
      log_in(@user)
      flash[:success] = t("password_reset.success")
      redirect_to(@user)
    else
      render(:edit)
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by(email: params[:email] || params.dig(:password_reset, :email)&.downcase)
    return if @user

    flash[:danger] = t("not_found_users")
    redirect_to(request.referer)
  end

  def valid_user
    return if @user.authenticated?(:reset, params[:id])

    flash[:danger] = t("password_reset.authenticated_error")
    redirect_to(login_path)
  end

  def check_user_actived
    return if @user.activated

    flash[:danger] = t("password_reset.actived_error")
    redirect_to(login_path)
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("password_reset.expired")
    redirect_to(new_password_reset_url)
  end

  def check_password_presence
    return unless user_params[:password].empty?

    flash[:error] = t("password_reset.wrong_password")
    redirect_to(request.referer)
  end
end
