class CreateReadings < ActiveRecord::Migration
  def up
    create_table :readings do |t|
      t.integer :cps
      t.integer :cpm
      t.float   :dose
      t.text    :mode
 
      t.timestamps
    end
  end
 
  def down
    drop_table :readings
  end
end
