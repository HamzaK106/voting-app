class DelegationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_phone_verified
  def show
    @delegate = current_user.delegate
    @delegators = current_user.delegators
  end

  def edit
    @users = User.where.not(id: current_user.id)
    @delegate = current_user.delegate
  end

  def update
    delegate_id = params[:user][:delegate_id]
    if delegate_id.present? && delegate_id.to_i != current_user.id
      # Prevent cycles
      if creates_cycle?(current_user, delegate_id.to_i)
        redirect_to edit_delegation_path, alert: 'Delegation would create a cycle! Choose another delegate.'
        return
      end
      current_user.update(delegate_id: delegate_id)
      redirect_to delegation_path, notice: 'Delegate updated successfully.'
    else
      current_user.update(delegate_id: nil)
      redirect_to delegation_path, notice: 'Delegate removed.'
    end
  end

  private

  # Prevent delegation cycles (A->B->C->A)
  def creates_cycle?(user, new_delegate_id)
    seen = Set.new([user.id])
    current = User.find_by(id: new_delegate_id)
    while current
      return true if seen.include?(current.id)
      seen << current.id
      current = current.delegate
    end
    false
  end

  def ensure_phone_verified
    unless current_user.phone_verified?
      redirect_to request_sms_verification_path, alert: 'You must verify your phone number before participating in voting.'
    end
  end
end
