class CreateWeights < ActiveRecord::Migration[5.1]
  def change
    create_table :weights do |t|
      t.references :degu, foreign_key: true
      t.references :measurment, foregn_key: true
      t.integer :value

      t.timestamps
    end
  end
end
