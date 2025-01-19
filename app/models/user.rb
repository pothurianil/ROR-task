class User < ApplicationRecord

    has_many :loans
    enum role: {admin: 0, user:1}
    has_secure_password
    before_create :check_admin
    after_create :add_balance
    has_many :confirm_loans
    has_many :addjustment_loans


    def check_admin
      if role == "admin"
        errors.add(:role, "Admin already present")
      end
    end
    
    def add_balance
       self. balance = 10000
    end
end
