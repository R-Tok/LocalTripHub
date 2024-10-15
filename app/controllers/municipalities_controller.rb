class MunicipalitiesController < ApplicationController
  def index
    if params[:prefecture_id].present?
      @municipalities = Municipality.where(prefecture_id: params[:prefecture_id])
    else
      @municipalities = Municipality.none
    end

    # キャッシュを無効化
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "municipality_select_frame", # 正しいフレーム名を指定
          partial: "spots/municipality_select",
          locals: { municipalities: @municipalities }
        )
      end
    end
  end
end
