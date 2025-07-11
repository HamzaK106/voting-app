class BallotsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_phone_verified
  before_action :set_election

  def create
    # Prevent double voting
    if @election.ballots.exists?(user: current_user)
      redirect_to election_path(@election), alert: 'You have already voted in this election.'
      return
    end

    # Expect params[:ranking] to be an array of candidate IDs in ranked order
    ranking = params[:ranking]
    unless ranking.is_a?(Array) && ranking.all? { |id| id.to_i.to_s == id.to_s }
      redirect_to election_path(@election), alert: 'Invalid ballot submission.'
      return
    end

    chain = delegation_chain_for(current_user)
    delegated = (chain.first != chain.last) # If chain length > 1, this is a delegated ballot
    ballot = @election.ballots.create!(user: current_user, delegated: delegated, delegation_chain: chain.join('>'))
    ranking.each_with_index do |candidate_id, idx|
      ballot.ballot_items.create!(candidate_id: candidate_id, rank: idx + 1)
    end

    redirect_to election_path(@election), notice: 'Your vote has been submitted!'
  end

  private

  def delegation_chain_for(user)
    chain = [user.id]
    while user.delegate
      user = user.delegate
      chain << user.id
      break if chain.size > 10 # Prevent infinite loops
    end
    chain
  end

  def ensure_phone_verified
    unless current_user.phone_verified?
      redirect_to request_sms_verification_path, alert: 'You must verify your phone number before participating in voting.'
    end
  end

  def set_election
    @election = Election.find(params[:election_id])
  end
end
