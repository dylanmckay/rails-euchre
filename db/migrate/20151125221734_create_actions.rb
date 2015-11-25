class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|

      t.integer :player_id
      t.references :player

      t.string :action_type, null: false
      t.string :suit
      t.integer :value

      t.timestamps null: false
    end
  end
end
