class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid   :user_id, null: false
      t.string :text

      t.timestamps
    end
  end
end
