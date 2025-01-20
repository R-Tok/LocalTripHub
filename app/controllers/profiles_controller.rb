class ProfilesController < ApplicationController
  before_action :set_user, only: %i[myposts show edit update unsubscribe destroy]

  def myposts
    @posts = @user.posts.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t("profiles.update.success")
    else
      flash.now[:danger] = t("profiles.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def unsubscribe; end

  def destroy
    @user.update(is_deleted: true)
    reset_session
    flash[:success] = "退会処理が完了しました"
    redirect_to root_path, data: { turbo: false }
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nickname, :introduction, :avatar, :avatar_cache)
  end
end
