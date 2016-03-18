class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :reply, default: "none"
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :invites, :users, column: :user_id
    add_foreign_key :invites, :events, column: :event_id
  end
end
