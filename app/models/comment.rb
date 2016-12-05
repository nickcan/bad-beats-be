class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates_presence_of :message, :post_id, :user_id

  class << self
    def get_latest_comments(size: 15, page: nil)
      order(:created_at).limit(size).offset(page)
    end
  end
end
