class SpotsController < ApplicationController
  def new
    @spot = Spot.new
    @municipalities = Municipality.includes(:prefecture).all
    @prefectures = Prefecture.all
  end

  def confirm
    @spot = current_user.spots.build(spot_params)
    @municipalities = Municipality.includes(:prefecture).all
    @prefectures = Prefecture.all

    if @spot.valid?
      render :confirm
    else
      flash.now[:danger] = t("spots.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @spot = current_user.spots.build(spot_params)

    if params[:back]
      redirect_to action: :new
    elsif @spot.save
      redirect_to new_spot_post_path(@spot), success: t("spots.create.success")
    else
      flash.now[:danger] = t("spots.create.failure")
      render :new, status: :unprocessable_entity, data: { turbo: false }
    end
  end

  def get_municipalities
    prefecture = Prefecture.find(params[:prefecture_id])
    municipalities = prefecture.municipalities.select(:id, :name)
    render json: municipalities
  end

  def select
    @spots = Spot.all
  end

  private

  def spot_params
    params.require(:spot).permit(:name, :latitude, :longitude, :prefecture_id, :municipality_id, category_ids: [])
  end
end
