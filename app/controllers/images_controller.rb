class ImagesController < ApplicationController
  def destroy
    @image = Image.find(params[:id])
    @image.destroy!
    redirect_to edit_spot_post_path(@image.post.spot, @image.post), status: :see_other, success: "画像が削除されました"
  end
end
