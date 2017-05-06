class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :email,
             :image_url,
             :name
end
