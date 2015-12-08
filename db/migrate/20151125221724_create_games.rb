class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|

      t.references :initial_dealer, references: :players, null: false
      t.string :initial_trump, null: false

      t.timestamps null: false
    end
  end
end
