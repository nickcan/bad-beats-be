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
    def get_latest_posts(page: nil, size: nil)
      size ||= 2
      order(:created_at).reverse_order.offset(size.to_i * page.to_i).limit(size.to_i)
    end

    def get_latest_posts_by_sport(page: nil, size: nil, sport: nil)
      size ||= 2
      where(sport: sport.downcase).order(:created_at).reverse_order.limit(size.to_i).offset(size.to_i * page.to_i)
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

  def serialize(current_user_id)
    {
      id: id,
      user_id: user_id,
      text: text,
      sport: sport,
      created_at: created_at,
      updated_at: updated_at,
      current_user_has_voted: votes.find_by(user_id: current_user_id).present?,
      vote_count: votes.count,
      comments: comments.order(:created_at).limit(5).map { |comment| comment.serialize(current_user_id) },
      images: images,
      tags: tags,
      user: user.serialize
    }
  end
end
