class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, id: :uuid do |t|
      t.uuid   :user_id, null: false
      t.string :text
      t.string :sport, index: true, null: false

      t.timestamps
    end
  end
end
