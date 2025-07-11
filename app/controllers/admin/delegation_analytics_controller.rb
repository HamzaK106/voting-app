class Admin::DelegationAnalyticsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @users = User.includes(:delegators)
    @top_delegates = @users.sort_by { |u| -u.all_delegators.count }.first(10)
    @total_delegated_votes = @users.sum { |u| u.all_delegators.count }
    @delegation_stats = @users.map { |u| [u, u.all_delegators.count] }.sort_by { |_, c| -c }
  end

  private

  def ensure_admin
    unless current_user.is_admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
