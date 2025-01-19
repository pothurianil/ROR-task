class AddColumnsTotalAmountInterestAmountInLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :total_amount, :integer 
    add_column :loans, :interest_loan, :integer
  end
end
