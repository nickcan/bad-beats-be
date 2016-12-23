class ImagesController < ApplicationController
  def create
    image = Image.new.initialize_magick_image(params[:file])
    image.resize(width: params[:width], height: params[:height])
    if image.upload_to_s3
      render json: image
    else
      render json: image.errors
    end
  end

  def show
    image = Image.find(params[:id])
    render json: image
  end
end
