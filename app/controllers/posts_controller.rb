class PostsController < ApplicationController
  before_action :set_spot, only: %i[new create index]

  def new
    @post = @spot.posts.build
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
    @posts = Post.where(spot_id: params[:spot_id])
  end

  private

  def post_params
    params.require(:post).permit(:access_info, :content)
  end

  def set_spot
    @spot = Spot.includes(:prefecture, :municipality).find(params[:spot_id])
  end
end
