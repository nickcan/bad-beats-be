class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :votable, dependent: :destroy

  validates_presence_of :post_id, :user_id
  validates :message, length: { maximum: 500 }, presence: true

  after_create :set_comment_count_on_post
  after_destroy :set_comment_count_on_post

  class << self
    def get_latest_comments(offset: nil, size: nil)
      size ||= 15

      includes(:user, :votes)
      .order(:created_at)
      .offset(offset.to_i)
      .limit(size.to_i)
    end
  end

  def set_comment_count_on_post
    post.update_attributes(comment_count: post.comments.count)
  end

  def serialize(current_user_id = nil)
    CommentSerializer.new(self, current_user_id: current_user_id).attributes
  end
end
