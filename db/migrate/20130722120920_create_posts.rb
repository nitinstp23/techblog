class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false, unique: true
      t.string :slug, null: false, unique: true
      t.integer :views_count, default: 0
      t.text :body

      t.timestamps
    end
  end
end
