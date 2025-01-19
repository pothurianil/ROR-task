class Loan < ApplicationRecord
  belongs_to :user

  has_many :confirm_loans
  has_many :addjustment_loans
  enum status: {requested: 0, approved: 1, open: 2, closed: 3, rejected: 4, waiting_for_adjustment_acceptance: 5, readjustment_requested: 6}

  after_update :create_confimration_loan
  before_validation :check_wallet_balance
  def create_confimration_loan
    if self.status == "approved"
      self.confirm_loans.create(user_id: self.user_id, status: 0)
    end

    if self.status == "waiting_for_adjustment_acceptance"
      self.addjustment_loans.create(user_id: self.user_id, status: 0) if self.ustment_loans.empty?
    end
    
  end

  def check_wallet_balance
    if self.amount > self&.user&.balance
      errors.add(:amount, "You don't have enough wallet balance to request loan")
    end
  end

  def self.search(params)
    loans = all 
    loans = loans.where(status: params[:status])
    loans
  end
end
