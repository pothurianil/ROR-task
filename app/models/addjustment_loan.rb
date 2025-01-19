class AddjustmentLoan < ApplicationRecord
    belongs_to :user 
    belongs_to :loan

    enum status: {pending: 0, accept: 1, rejected: 2, readjustment: 3}

    after_update :update_loan_status

  def update_loan_status
     loan_status = self.status 

    #  self.loan.update(status: loan_staus)

     if loan_status == "accept"
      self.loan.update(loan_issued_date: DateTime.now, status: "open")

      admin = User.admin.first
      admin.update(balance: admin.balance - self.loan.amount)
     end

    self.loan.update(status: "readjustment_requested") if loan_status == "readjutment"
    self.loan.update(status: loan_status) if loan_status == "rejected"
  end

#   def checking 
#     if status == "closed"
#         interest = obj.amount * 0.01 * obj.interest

#         obj.update(total_amoun: object.amount+interest, interest_loan: interest)
#     end

#      if user.balance <= obj.total_amount
#         loan.update(sttaus: "closed")
#      end
#   end
end
