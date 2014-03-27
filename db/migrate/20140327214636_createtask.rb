class Createtask < ActiveRecord::Migration
  def change
    create_table :tasks do |t|

      t.column :desc, :string

      t.timestamps
    end
  end
end
