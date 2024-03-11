class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params.dig(:micropost, :image))
    if @micropost.save
      flash[:success] = t("microposts.add_success")
      redirect_to(current_user)
    else
      @pagy, @feed_items = pagy(current_user.feed, items: Settings.page_5)
      render("static_pages/home", status: :unprocessable_entity)
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("microposts.destroy_success")
    else
      flash[:danger] = t("microposts.destroy_fails")
    end
    redirect_to(request.referer)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:danger] = t("micoposts.invalid_micropost")
    redirect_to(request.referer)
  end
end
