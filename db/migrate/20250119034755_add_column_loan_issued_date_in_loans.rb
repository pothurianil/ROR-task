class AddColumnLoanIssuedDateInLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :loan_issued_date, :datetime
  end
end
