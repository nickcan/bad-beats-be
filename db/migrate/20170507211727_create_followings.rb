class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :follower_id, null: false
      t.boolean :blocked, null: false, default: false

      t.timestamps
    end
  end
end
