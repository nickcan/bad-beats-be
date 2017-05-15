class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :provider
      t.string :uid
      t.string :email, null: false, unique: true
      t.integer :follower_count, null: false, default: 0
      t.integer :following_count, null: false, default: 0
      t.integer :post_count, null: false, default: 0
      t.string :name
      t.text   :short_bio
      t.string :image_url
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
