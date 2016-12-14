class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :post_id
      t.uuid :tag_id

      t.timestamps
    end
  end
end
