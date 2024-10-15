# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "csv"

CSV.foreach('db/pref_municipalities.csv', headers: true) do |row|
  prefecture = Prefecture.find_or_create_by!(name: row['prefecture'])

  Municipality.create!(
    name: row['municipality'],
    prefecture: prefecture
  )
end

Category.create(
  [
    { name: '公園・遊歩道・庭園' }, { name: '城・史跡・寺院・神社' }, { name: '動物園・水族館・植物園' },
    { name: '博物館・美術館 [歴史記念館・科学館]' }, { name: '文化・芸能 [図書館・ホール・映画館・ギャラリー]' }, { name: 'ショッピング [ショッピングモール・商店街・市場・お土産]' },
    { name: '飲食店 [カフェ・レストラン・飲食店街]' }, { name: '酒蔵・ワイナリー' }, { name: '体験施設・農場 [伝統文化・工房・農業体験]' },
    { name: '町並み・通りその他ランドマーク [保存地区・湧水・モニュメント]' }, { name: '自然景観・展望台 [海岸・山岳・その他景勝地]' }, { name: 'スポーツ・アクティビティ [スポーツ施設・遊園地・キャンプ・アウトドア]' },
    { name: '宿泊・温泉 [入浴施設・ホテル・民宿]' }, { name: '道の駅・サービスエリア' }, { name: '交通 [駅・空港・港・バスターミナル・レンタサイクル]' }
  ]
)

puts "Prefectures and Municipalities imported successfully!"
puts "Categories imported successfully!"
