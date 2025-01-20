class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  before_action :set_user_and_check_access, only: %i[show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(user_params[:email], user_params[:password])
      redirect_to root_path, success: t("users.create.success")
    else
      flash.now[:danger] = t("users.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

   def show
    @user = User.find_by(id: params[:id])
    redirect_to profile_path if @user.id == current_user.id

    @posts = @user.posts.includes(:images).order(created_at: :desc).page(params[:page])
   end

  private

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end

  def set_user_and_check_access
    @user = User.find_by(id: params[:id])
    if !@user.present? || @user.is_deleted?
      render file: "public/404.html"
    else
      render_404(@user)
    end
  end
end
