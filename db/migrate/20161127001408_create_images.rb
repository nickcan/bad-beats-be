class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, id: :uuid do |t|
      t.integer :width
      t.integer :height
      t.string  :format
      t.string  :object_key
      t.string  :url

      t.timestamps
    end
  end
end
