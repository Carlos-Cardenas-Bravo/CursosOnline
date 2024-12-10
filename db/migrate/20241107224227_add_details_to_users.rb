class AddDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :nombre, :string
    add_column :users, :apellido, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :edad, :integer
    add_column :users, :sexo, :string
    add_column :users, :receive_updates, :boolean
  end
end
