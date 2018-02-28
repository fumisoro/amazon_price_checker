class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.integer :product_id
      t.integer :value
      t.string :value_string

      t.timestamps
    end
  end
end
