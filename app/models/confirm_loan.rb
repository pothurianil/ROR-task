class ConfirmLoan < ApplicationRecord
  belongs_to :loan
  belongs_to :user
  enum status: {pending:0, confirmed: 1, rejected: 2}
   
  after_update :update_loan_status

  def update_loan_status
    
     loan_staus = self.status == "confirmed" ? "open" : "rejected"

     self.loan.update(status: loan_staus)

     if loan_staus == "open"
      self.loan.update(loan_issued_date: DateTime.now)
      admin = User.admin.first
      admin.update(balance: admin.balance - self.loan.amount)
     end
  end
end
