class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index municipality_spot_counts site_policy privacy_policy]

  def index
    @posts = Post.includes(:user).where(users: { is_deleted: false }).order(created_at: :desc).limit(3)
    @prefecture_spots_count = Prefecture.joins(spots: { posts: :user }).where(users: { is_deleted: false }).group(:name).distinct.count("spots.id")
  end

  def posts_browse
    @spots = Spot.all
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).where(users: { is_deleted: false }).order(created_at: :desc).page(params[:page])
  end

  def site_policy; end

  def privacy_policy; end

  def municipality_spot_counts
    # JSONファイルの指定
    geojson_path = Rails.root.join("public", "N03-20240101_municipality.geojson")
    geojson_data = File.read(geojson_path)
    geojson = JSON.parse(geojson_data)

    # DB上で市町村ごとのスポット数を一括取得
    municipality_spot_counts = Spot.joins(posts: :user).where(users: { is_deleted: false }).group(:municipality_id).distinct.count

    # GeoJSONデータに含まれる市町村名に対応するデータを取得
    municipalities = Municipality.joins(spots: :posts).where(name: geojson["features"].map { |f| f["properties"]["N03_008"] })

    # 市町村名をキーとしたハッシュを作成。名前による検索が高速で可能に
    municipality_map = municipalities.index_by { |m| "#{m.prefecture.name}#{m.name}" }

    # 各市町村にspot_countを追加する
    geojson["features"].each do |feature|
      key = "#{feature["properties"]["N03_001"]}#{feature["properties"]["N03_008"]}" # 県名+市町村名のキーを作る

      # 市町村をハッシュから検索
      municipality = municipality_map[key]

      # スポット数を取得して追加
      spot_count = municipality.present? ? municipality_spot_counts[municipality.id] || 0 : 0
      feature["properties"]["spot_number"] = spot_count
    end

    render json: geojson
  end
end
