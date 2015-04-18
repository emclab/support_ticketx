# This migration comes from authentify (originally 20150328095843)
class AddNewColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :authentify_users, :last_time_password_changed, :date
    add_column :authentify_users, :previous_passwords, :text
    add_column :authentify_users, :systems_access_tokens, :text
  end
end
