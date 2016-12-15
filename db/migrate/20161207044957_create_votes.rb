class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid    :user_id, null: false
      t.uuid    :votable_id
      t.string  :votable_type

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_id], unique: true
  end
end
