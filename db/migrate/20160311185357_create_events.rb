class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :event_date
      t.references :host, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
