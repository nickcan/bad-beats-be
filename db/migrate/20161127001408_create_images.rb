class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid    :imageable_id
      t.string  :imageable_type

      t.integer :width
      t.integer :height
      t.string  :format
      t.string  :object_key
      t.string  :url

      t.timestamps
    end
  end
end
