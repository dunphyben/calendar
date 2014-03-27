class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :desc, :string
      t.column :location, :string
      t.column :start_time, :datetime
      t.column :end_time, :datetime

      t.timestamps
    end
  end
end

