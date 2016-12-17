class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :provider
      t.string :uid
      t.string :email, null: false, unique: true
      t.string :name
      t.string :image_url
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
