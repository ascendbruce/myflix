class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true
      t.integer    :amount
      t.string     :reference_id

      t.timestamps
    end
  end
end
