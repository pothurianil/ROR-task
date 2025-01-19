class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token  
	include Authenticable
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    def record_not_found
      render json: 'record not found'
    end
end
