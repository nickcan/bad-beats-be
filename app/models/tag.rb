class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings

  validates :name, presence: true, uniqueness: true

  def self.search(name = "")
    where("lower(name) LIKE ?", "%#{name.downcase}%").
    joins(:posts).
    group("tags.id").
    select("tags.id, tags.name, count(*) as num_posts").
    order("num_posts").
    reverse_order.
    limit(10)
  end
end
