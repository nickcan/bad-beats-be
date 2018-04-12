class AddContextToImages < ActiveRecord::Migration
  def change
    add_column :images, :context, :string
    add_column :images, :status, :string
  end
end
