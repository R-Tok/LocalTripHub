class PostsController < ApplicationController
  before_action :set_spot_and_check_access
  before_action :set_post_and_check_access, only: %i[show edit update destroy]

  def new
    @post = @spot.posts.build
    @post.images.build
  end

  def create
    @post = @spot.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to spot_posts_path(@spot), success: "投稿が作成されました"
    else
      flash.now[:danger] = "投稿の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.where(spot_id: params[:spot_id]).order(created_at: :desc).page(params[:page])
  end

  def show; end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to spot_post_path(@spot), success: "投稿が更新されました"
    else
      flash.now[:danger] = "投稿の更新に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to spot_posts_path(@spot), status: :see_other, success: "投稿が削除されました"
  end

  private

  def post_params
    params.require(:post).permit(:access_info, :content, images_attributes: [ :image_url, :image_url_cache ])
  end

  def set_spot_and_check_access
    @spot = Spot.includes(:prefecture, :municipality).find_by(id: params[:spot_id])
    render_404(@spot)
  end

  def set_post_and_check_access
    @post = Post.find_by(id: params[:id])
    render_404(@post)

    if @post.spot_id != @spot.id
      render file: "public/404.html"
    end
  end
end
