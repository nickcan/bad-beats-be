class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, id: :uuid do |t|
      t.integer :height
      t.integer :width
      t.string  :format
      t.string  :object_key
      t.string  :url

      t.timestamps
    end
  end
end
