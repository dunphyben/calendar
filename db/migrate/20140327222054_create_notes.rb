class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.column :name, :string
      t.column :notable_id, :int
      t.column :notable_type, :string

      t.timestamps
    end
  end
end
