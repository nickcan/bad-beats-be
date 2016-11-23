class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :email, uniqueness: true

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
end
