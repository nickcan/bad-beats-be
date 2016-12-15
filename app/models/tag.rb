class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings

  validates :name, presence: true, uniqueness: true

  def self.search(name)
    if name.blank?
      all.limit(25)
    else
      where('lower(name) LIKE ?', "%#{name.downcase}%").limit(25)
    end
  end
end
