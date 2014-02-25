class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :posts, :slug, unique: true
    add_index :users, :name, unique: true

    change_column :posts, :body, :text, null: false
  end
end
