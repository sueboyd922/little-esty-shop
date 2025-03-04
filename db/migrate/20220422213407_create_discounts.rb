class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.integer :quantity
      t.integer :percent_discount
      t.references :merchant, foreign_key: true
    end
  end
end
