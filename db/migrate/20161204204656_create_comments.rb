class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid   :post_id, null: false
      t.uuid   :user_id, null: false
      t.string :message, null: false

      t.timestamps
    end
  end
end
