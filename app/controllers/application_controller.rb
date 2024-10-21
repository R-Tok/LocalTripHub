class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_action :require_login
  add_flash_types :success, :danger

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
end
