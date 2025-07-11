require 'csv'

class ElectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_phone_verified
  before_action :ensure_election_open, only: [:show]

  def index
    @elections = Election.order(starts_at: :desc)
  end

  def show
    @election = Election.find(params[:id])
    @candidates = @election.candidates.order(:name)
    @ballot = current_user.ballots.find_by(election: @election)
  end

  def results
    @election = Election.find(params[:id])
    @rcv = RcvService.new(@election).calculate
    @candidates = @election.candidates.index_by(&:id)
    @ballots = @election.ballots.includes(:user)

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=rcv_results_#{@election.id}.csv"
        headers['Content-Type'] ||= 'text/csv'
        render plain: rcv_to_csv(@rcv, @candidates)
      end
      format.json do
        render json: {
          election: @election.title,
          rounds: @rcv.rounds,
          eliminated_order: @rcv.eliminated_order,
          winner: @candidates[@rcv.winner]&.name
        }
      end
    end
  end

  private

  def ensure_phone_verified
    unless current_user.phone_verified?
      redirect_to request_sms_verification_path, alert: 'You must verify your phone number before accessing elections.'
    end
  end

  def ensure_election_open
    @election = Election.find(params[:id])
    now = Time.current
    if now < @election.starts_at
      redirect_to elections_path, alert: 'This election has not started yet.'
    elsif now > @election.ends_at
      redirect_to elections_path, alert: 'This election is closed.'
    end
  end

  def rcv_to_csv(rcv, candidates)
    CSV.generate do |csv|
      csv << ["Round", "Candidate", "Votes", "Eliminated"]
      rcv.rounds.each_with_index do |round, idx|
        round[:results].each do |res|
          eliminated = rcv.eliminated_order[idx]&.include?(res[:candidate_id]) ? 'Yes' : ''
          csv << [round[:round], res[:candidate_name], res[:votes], eliminated]
        end
      end
    end
  end
end
