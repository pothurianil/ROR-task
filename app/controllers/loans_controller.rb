class LoansController < ApplicationController 
    before_action :check_user, only:  [:create, :update_confirm_loan]
    before_action :check_admin, only: [:update, :requested_loans]
    def create
        loan =  current_user.loans.create(set_params.merge(status: 0))
        if loan.save 
           render json: {loan: LoanSerializer.new(loan)}
        else
           render json: {errors: loan.errors}
        end
    end
    
    def requested_loans
      loans = Loan.all.where(status: 0)
      render json: loans
    end

    def update
       loan = Loan.find_by(id: params[:id])
       if loan.update(status: params[:status])
          render json: {message: "you updated the loan as #{loan.status}"}
       else
          render json: loan.errors
       end
    end

    def update_confirm_loan
       confirm_loan = ConfirmLoan.find_by(id: params[:id])
       if  current_user.id == confirm_loan.user_id 
          render json: {message: "You already #{confirm_loan.status} the loan"} and return  unless confirm_loan.status =="pending"
          
          if confirm_loan.update(set_params)
            render json: confirm_loan
          else
            render json: {errors: confirm_loan.errors}
          end
       else
          render json: {message: "your not owner fore the this record"}
       end
    end

    def list_of_confirmation_loans
        confirm_loans = current_user.confirm_loans
        render json: confirm_loans
    end

    def current_user_loans
      if params[:status].present?
      loans = current_user.loans.search(params)
      render json: loans
      else 
         render json: {message: "Please select a status filter"}
      end
    end

    def list_of_addjustment_loans
      addjustment_loans = current_user.addjustment_loans
      render json: addjustment_loans
    end

    def update_addjustment_loan
      loan = current_user.addjustment_loans.find(params[:id])

      if loan.update(status: params[:status])
         render json: loan 
      else
         render json: {errors: loan.errors}
      end
    end

    def repay_the_loan
      loan = current_user.loans.find(params[:id])
      render json: {message: "This loan are already closed"} and return if loan.status == "closed"
      if loan.total_amount.nil?
        
         interest = loan.amount * 0.01 * loan.interest   
         total_amount = loan.amount + interest
         
      else
         interest = loan.interest_loan
         total_amount = loan.total_amount
      end

      if params[:amount] >= total_amount
         loan.update(status: "closed", total_amount: total_amount, interest_loan: interest)
         render json: {message: "You have succefully repay the amount #{total_amount}",
                       loan: loan}
      else
         render json: "You have to pay #{total_amount}"
      end
    end

    private

    def set_params 
      params.permit(:amount, :interest, :status)
    end

    def check_user
        render json: {message: "Your not authorized"} unless current_user.role == "user"
    end

    def check_admin
        render json: {message: "Your not authorized"} unless current_user.role == "admin" 
    end
end