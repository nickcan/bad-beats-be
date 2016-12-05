class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  validates :url, presence: true

  after_destroy :delete_s3_object

  attr_reader :magick_image

  def delete_s3_object
    if s3_object && s3_object.exists?
      s3_object.delete
    end
  end

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
    s3_object.put(body: magick_image.to_blob, acl: "public-read")
    self.url = s3_object.public_url
    save!
  end

  def s3_object
    @_s3_object ||= s3_bucket.object(self.object_key)
  end

  private

  def s3_resource
    @_s3_resource ||= Aws::S3::Resource.new(region: 'us-west-1')
  end

  def s3_bucket
    @_s3_bucket ||= s3_resource.bucket('bad-beats-images')
  end
end
