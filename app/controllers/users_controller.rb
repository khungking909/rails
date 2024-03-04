# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :load_user, only: [:edit,:show]
  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:succes_singup] = t("succes_singup")
      redirect_to(@user)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:warning] = t("not_found_users")
    redirect_to(root_path)
  end
end
