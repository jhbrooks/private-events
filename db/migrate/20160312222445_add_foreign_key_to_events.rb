class AddForeignKeyToEvents < ActiveRecord::Migration
  def change
    add_foreign_key :events, :users, column: :host_id
  end
end
