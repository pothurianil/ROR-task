class CreateConfirmLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :confirm_loans do |t|
      t.references :loan, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
