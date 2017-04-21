class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings

  validates :user_id, presence: true
  validates :text, length: { maximum: 500 }, allow_blank: true
  validates :sport, presence: true

  class << self
    def get_latest_posts(size: nil, page: nil)
      size ||= 2
      order(:created_at).reverse_order.offset(size.to_i * page.to_i).limit(size)
    end

    def get_latest_posts_by_sport(size: nil, page: nil, sport: nil)
      size ||= 2
      where(sport: sport).order(:created_at).reverse_order.limit(size).offset(size.to_i * page.to_i)
    end
  end

  def create_image_and_upload_to_s3(file)
    image = self.images.new.initialize_magick_image(file)
    image.upload_to_s3
  end

  def first_or_create_tags(tagNames)
    tagNames.each do |tagName|
      tag = Tag.where(name: tagName).first_or_create name: tagName
      Tagging.create post_id: self.id, tag_id: tag.id
    end
  end

  def serialize
    {
      id: id,
      user_id: user_id,
      text: text,
      sport: sport,
      created_at: created_at,
      updated_at: updated_at,
      images: images,
      tags: tags,
      user: user.serialize
    }
  end
end
