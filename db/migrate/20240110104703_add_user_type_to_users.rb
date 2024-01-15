# frozen_string_literal: true

class AddUserTypeToUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column(:users, :user_type, :integer, default: nil)
    add_column(:users, :user_type, :integer)
  end
end
