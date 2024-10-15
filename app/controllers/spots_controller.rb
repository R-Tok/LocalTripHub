class SpotsController < ApplicationController
  def new
    @spot = Spot.new
  end

  def create
    @spot = current_user.spots.build(spot_params)

    if @spot.save
      redirect_to root_path, success: "スポットの作成に成功しました"
    else
      flash.now[:danger] = "スポットの作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def spot_params
    params.require(:spot).permit(:name, :latitude, :longitude, :prefecture_id, :municipality_id, category_ids: [])
  end
end
