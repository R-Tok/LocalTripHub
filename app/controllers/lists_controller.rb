class ListsController < ApplicationController
  before_action :set_user_and_check_access
  before_action :set_list_and_check_access, only: %i[show update destroy]

  def index
    @lists = @user.lists.includes(:posts).order(created_at: :desc)
    @list = @user.lists.new
  end

  def create
    @list = @user.lists.new(list_params)

    respond_to do |format|
      if @list.save
        redirect_to user_lists_path, success: "リストを作成しました"
      else
        render :index, status: :unprocessable_entity, flash: { danger: "リスト作成に失敗しました" }
      end
    end
  end

  def show
    @posts = @list.posts.order(created_at: :desc).page(params[:page])
  end

  def update
    @list.update(list_params)

    respond_to do |format|
      if @list.save
        redirect_to user_list_path, success: "リストを編集しました"
      else
        render :index, status: :unprocessable_entity, flash: { danger: "リスト作成に失敗しました" }
      end
    end
  end

  def destroy
    @list.destroy!
    redirect_to user_lists_path(@user), data: { turbo: false }, status: :see_other, success: t("lists.delete")
  end

  private

  def list_params
    params.require(:list).permit(:name, :caption)
  end

  def set_user_and_check_access
    @user = User.find_by(id: params[:user_id])
    render file: "public/404.html" if @user.is_deleted? || @user.nil?
  end

  def set_list_and_check_access
    @list = List.find_by(id: params[:id])
    if !@list.present?
      render_404(@list)

    elsif @list.user_id != @user.id
      render file: "public/404.html"
    end
  end
end
