class User < ActiveRecord::Base
  has_secure_password

  has_many :comments, dependent: :destroy
  has_many :followers, class_name: 'Followings', foreign_key: 'user_id'
  has_many :following, class_name: 'Followings', foreign_key: 'follower_id'
  has_many :posts, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  class << self
    def from_omniauth(auth_hash)
      user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
      user.email = auth_hash['info']['email']
      user.name = auth_hash['info']['name']
      user.image_url = auth_hash['info']['image']
      user.password = user.password_confirmation = ""
      user.password_digest = "facebook-authorized account"
      user.save!
      user
    end
  end

  def format_with_following_status(active_user_is_following)
    {
      user: UserSerializer.new(self).attributes,
      active_user_is_following: active_user_is_following
    }
  end

  def format_with_jwt_payload
    {
      auth_token: JsonWebToken.encode({user_id: self.id}),
      user: UserSerializer.new(self).attributes
    }
  end

  def is_following?(user_id)
    following.find_by(user_id: user_id).present?
  end

  def search_followers(page: nil, size: nil)
    size ||= 50

    followers.includes(:user)
    .offset(size.to_i * page.to_i)
    .limit(size.to_i)
  end

  def search_following(page: nil, size: nil)
    size ||= 50

    following.includes(:follower)
    .offset(size.to_i * page.to_i)
    .limit(size.to_i)
  end
end
