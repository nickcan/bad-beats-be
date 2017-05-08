class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :email,
             :image_url,
             :name,
             :follower_count,
             :following_count
end
