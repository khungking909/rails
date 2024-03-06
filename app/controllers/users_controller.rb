# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(new index create)
  before_action :correct_user, only: %i(edit update show)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.page_5)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = t("succes_singup")
      redirect_to(@user)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t("profile_updated")
      redirect_to(@user)
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("user_deleted")
    else
      flash[:danger] = t("delete_fail")
    end
    redirect_to(users_path)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t("not_found_users")
    redirect_to(login_path)
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("mess_pls_login")
    store_location
    redirect_to(login_url)
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t("can_not_edit")
    redirect_to(signup_path)
  end

  def admin_user
    return if current_user.admin?

    flash[:error] = t("permission_denied")
    redirect_to(login_path)
  end
end
