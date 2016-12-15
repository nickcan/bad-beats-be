class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, index: true, null: false

      t.timestamps
    end
  end
end
