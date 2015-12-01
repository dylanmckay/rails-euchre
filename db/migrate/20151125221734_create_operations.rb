class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|

      t.integer :player_id
      t.references :player

      t.string :action_type, null: false
      t.string :suit
      t.integer :value

      t.timestamps null: false
    end
  end
end
