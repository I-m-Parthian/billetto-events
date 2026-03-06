class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.bigint :billetto_id, null: false
      t.string :title
      t.text :description
      t.string :image_link
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    add_index :events, :billetto_id, unique: true
  end
end
