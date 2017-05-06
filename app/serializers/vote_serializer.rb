class VoteSerializer < ActiveModel::Serializer
  belongs_to :user

  attributes :id,
             :votable_id,
             :votable_type,
             :created_at
             :updated_at
end
