# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :load_user, :authen_user, only: :create

  def new
    @user = User.new
  end

  def create
    if @user.activated?
      log_in(@user)
      params.dig(:session, :remember_me) == "1" ? remember(@user) : forget(@user)
      redirect_back_or(@user)
    else
      flash[:danger] = t("activation_fail")
      redirect_to(login_path)
    end
  end

  def destroy
    log_out
    redirect_to(login_path)
  end

  private

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:error] = t("login_email_err")
    render(:new, status: :unprocessable_entity)
  end

  def authen_user
    return if @user.authenticate(params.dig(:session, :password))

    flash.now[:error] = t("login_password_err")
    render(:new, status: :unprocessable_entity)
  end
end
