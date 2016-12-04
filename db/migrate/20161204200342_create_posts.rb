class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, id: :uuid do |t|
      t.belongs_to :user, index: true
      t.string :text

      t.timestamps
    end
  end
end
