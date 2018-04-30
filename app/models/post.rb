class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings

  validates :user_id, presence: true
  validates :text, length: { maximum: 800 }, allow_blank: true
  validates :sport, presence: true

  after_create :set_post_count_on_user
  after_destroy :set_post_count_on_user

  scope :descend_order, -> { order(:created_at) }

  scope :include_associated_info, -> {
    includes(:user, :images, :tags, :votes, comments: [:user, :votes])
  }

  scope :of_followed_users, -> (follow_ids = nil) {
    follow_ids ||= []
    where(user_id: follow_ids) unless follow_ids.empty?
  }

  scope :by_sport, -> (sport = nil) {
    where(sport: sport.downcase) unless sport.blank?
  }

  class << self
    def get_latest_posts(page: nil, size: nil, sport: nil)
      size ||= 25

      include_associated_info
        .by_sport(sport)
        .descend_order
        .reverse_order
        .offset(size.to_i * page.to_i)
        .limit(size.to_i)
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

  def set_post_count_on_user
    user.update_attributes(post_count: user.posts.count)
  end

  def serialize(current_user_id = nil)
    PostSerializer.new(self, current_user_id: current_user_id).attributes
  end
end
