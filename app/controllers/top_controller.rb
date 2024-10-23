class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @prefecture_spots_count = Prefecture.joins(spots: :posts).group(:name).distinct.count("spots.id")
  end


  def municipality_spot_counts
    # JSONファイルの読み込み
    geojson_path = Rails.root.join("public", "N03-20240101_municipality.geojson")
    geojson_data = File.read(geojson_path)
    geojson = JSON.parse(geojson_data)

    # 市町村ごとのスポット数を一括取得
    municipality_spot_counts = Spot.group(:municipality_id).count

    # 各市町村にspot_countを追加
    geojson["features"].each do |feature|
      prefecture_name = feature["properties"]["N03_001"] # 県名
      municipality_name = feature["properties"]["N03_004"] # 市町村名

      # 市町村を見つける
      municipality = Municipality.joins(spots: :posts).find_by(name: municipality_name)

      # スポット数を取得して追加
      spot_count = municipality.present? ? municipality_spot_counts[municipality.id] || 0 : 0
      feature["properties"]["spot_number"] = spot_count
    end

    render json: geojson
  end
end
