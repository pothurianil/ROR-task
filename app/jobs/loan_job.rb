class LoanJob < ApplicationJob
    queue_as :default

    def perform
        loans = Loan.where(status: "open")
        loans.each do |loan|
            amount = loan.amount
            interest_rate = loan.interest
            if loan.total_amount.nil?
            interest = amount * 0.01 *interest_rate 
            total_amount = amount + interest
            else 
              interest  = loan.interest_loan + (amount * 0.01 * interest_rate )
              total_amount = amount + interest

            end
            loan.update(total_amount: total_amount, interest_loan: interest)
            user = loan&.user
           if total_amount >= user&.balance
              loan.update(status: "closed")
              admin = User.find_by(role: "admin")
              admin.update(balance: admin.balance+total_amount)
              user.update(balance: user.balance - total_amount)
           end
        end

    end
end