class AddPasswordLengthToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :password_length, :integer
  end
end
