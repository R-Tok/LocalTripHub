class PostsController < ApplicationController
  before_action :set_spot_and_check_access
  before_action :set_post_and_check_access, only: %i[show edit update destroy]

  skip_before_action :require_login, only: %i[show], if: -> { from_top_page? }

  def new
    @post = @spot.posts.build
    @post.images.build
  end

  def create
    @post = @spot.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to spot_posts_path(@spot), success: t("posts.create.success")
    else
      flash.now[:danger] = t("posts.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.includes(:user, :spot).where(spot_id: params[:spot_id], users: { is_deleted: false }).order(created_at: :desc).page(params[:page])
  end

  def show; end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to spot_post_path(@spot), success: t("posts.update.success")
    else
      flash.now[:danger] = t("posts.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to spot_posts_path(@spot), data: { turbo: false }, status: :see_other, success: t("posts.delete")
  end

  private

  def post_params
    params.require(:post).permit(:access_info, :content, images_attributes: [ :id, :image_url, :post_id ])
  end

  def set_spot_and_check_access
    @spot = Spot.includes(:prefecture, :municipality).find_by(id: params[:spot_id])
    if !@spot.present?
      render file: "public/404.html"
    end
  end

  def set_post_and_check_access
    @post = Post.find_by(id: params[:id])
    if !@post.present?
      render_404(@post)

    elsif @post.spot_id != @spot.id || @post.user.is_deleted?
      render file: "public/404.html"
    else
      render_404(@post)
    end
  end

  def from_top_page?
    request.referer == root_url
  end
end
