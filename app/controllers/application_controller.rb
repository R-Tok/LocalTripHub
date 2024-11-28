class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_action :require_login
  add_flash_types :success, :danger

  def require_login
    unless logged_in?
      if social_media_crawler?
        # SNSクローラーにはリダイレクトせず、OGP情報を取得させる
        # ただしコンテンツの表示は制限する
      else
        # 通常のユーザーにはログインページへリダイレクト
        redirect_to login_path, flash: { danger: "ログインが必要です" }
      end
    end
  end

  def rescue_to_404
    render file: "public/404.html"
  end

  private

  def not_authenticated
    redirect_to login_path
  end

  def render_404(object)
    case action_name
    when "show", "index"
      render file: "public/404.html" if object.nil?
    when "edit", "update", "destroy"
      render file: "public/404.html" if object.nil? || current_user.id != object.user_id
    end
  end

  def social_media_crawler?
    user_agent = request.user_agent.to_s.downcase

    # よく使われるサービスのクローラーを判定
    user_agent.match?(
      /(facebookexternalhit|twitterbot|linkedinbot|slackbot|notebot|notion|line|whatsapp|pinterest|tumblr)/
    )
  end
end
