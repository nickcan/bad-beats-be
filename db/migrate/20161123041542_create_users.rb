class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :name
      t.string :image_url
      t.string :password_digest

      t.timestamps
    end
  end
end
