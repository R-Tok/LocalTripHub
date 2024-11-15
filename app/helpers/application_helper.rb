module ApplicationHelper
  def page_title(title = "")
    base_title = "LocalTripHub"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def default_meta_tags
    {
      site: "LocalTripHub",
      title: page_title(content_for(:title)),
      reverse: true,
      charset: "utf-8",
      description: "全国のローカルスポットを発掘し、1892市区町村の地図を塗りつぶそう。",
      keywords: "旅行記録, 共有サービス",
      canonical: request.original_url,
      separator: "|", # Webサイト名とページタイトルを区切るために使用されるテキスト
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: root_url + asset_path("OGP.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        image: root_url + asset_path("OGP.png")
      }
    }
  end

  def page_title(title)
    title.presence || "LocalTripHub"
  end
end
