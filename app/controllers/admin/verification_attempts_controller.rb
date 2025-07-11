class Admin::VerificationAttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  
  def index
    @verification_attempts = VerificationAttempt.includes(:user)
                                               .order(created_at: :desc)
                                               .page(params[:page])
                                               .per(50)
    
    # Statistics
    @total_attempts = VerificationAttempt.count
    @successful_attempts = VerificationAttempt.successful.count
    @failed_attempts = VerificationAttempt.failed.count
    @recent_attempts = VerificationAttempt.recent.count
    
    # Filter by success status
    if params[:success].present?
      @verification_attempts = @verification_attempts.where(success: params[:success] == 'true')
    end
    
    # Filter by date range
    if params[:date_from].present?
      @verification_attempts = @verification_attempts.where('created_at >= ?', Date.parse(params[:date_from]))
    end
    
    if params[:date_to].present?
      @verification_attempts = @verification_attempts.where('created_at <= ?', Date.parse(params[:date_to]) + 1.day)
    end
  end

  private

  def ensure_admin
    unless current_user.is_admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
