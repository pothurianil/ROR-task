class LoanSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :amount, :interest, :total_amount, :interest_loan, :user
end
