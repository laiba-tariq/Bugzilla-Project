# frozen_string_literal: true

class AddEnumUserTypeToUsers < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    remove_column :users, :usertype, :integer
  end
end
