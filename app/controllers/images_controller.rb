class ImagesController < ApplicationController
  def create
    image = MiniMagick::Image.open(params[:file])
    s3 = Aws::S3::Resource.new(region: 'us-west-1')
    object_key = SecureRandom.uuid
    obj = s3.bucket('bad-beats-images').object(object_key)
    obj.put(body: image.to_blob, acl: "public-read")
    if obj.public_url
      new_image = Image.new(
        height: image.height,
        width: image.width,
        format: image.details["Format"],
        object_key: object_key,
        url: obj.public_url
      )
      if new_image.save
        render json: new_image.to_json
      else
        obj.delete
        render json: new_image.errors.to_json
      end
    else
      render json: "error occured uploading image"
    end
  end

  def show
    image = Image.find(params[:id])
    render json: image.to_json
  end
end
