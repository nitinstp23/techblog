class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name,            null: false, unique: true
      t.string  :password_digest, null: false
      t.integer :sign_in_count,   null: false, default: 0
      t.timestamps
    end
  end
end
