class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes, id: :uuid do |t|
      t.uuid    :user_id
      t.uuid    :votable_id
      t.string  :votable_type

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_id], unique: true
  end
end
