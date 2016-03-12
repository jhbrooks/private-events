class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :event_date
      t.references :host, index: true

      t.timestamps null: false
    end
    add_foreign_key :events, :users, column: :host_id
  end
end
