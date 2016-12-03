class Image < ActiveRecord::Base
  attr_reader :magick_image, :s3_obj

  def initialize_magick_image(file)
    @magick_image ||= MiniMagick::Image.open(file)
    self.width  = magick_image.width
    self.height = magick_image.height
    self.format = magick_image.type
    self.object_key = SecureRandom.uuid
    self
  end

  def resize(width: nil, height: nil)
    magick_image.resize "#{width || magick_image.width}x#{height || magick_image.height}"
    self.width  = magick_image.width
    self.height = magick_image.height
    self
  end

  def upload_to_s3
    s3 = Aws::S3::Resource.new(region: 'us-west-1')
    @s3_obj = s3.bucket('bad-beats-images').object(self.object_key)
    s3_obj.put(body: magick_image.to_blob, acl: "public-read")
    self.url = s3_obj.public_url
    save!
  end
end
