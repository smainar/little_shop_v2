class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :active, default: true
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
