class CreateAddjustmentLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :addjustment_loans do |t|
      t.references :loan
      t.references :user
      t.integer :status

      t.timestamps
    end
  end
end
