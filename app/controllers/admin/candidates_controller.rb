class Admin::CandidatesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_election
  before_action :set_candidate, only: [:edit, :update, :destroy]

  def index
    @candidates = @election.candidates.order(:name)
    @candidate = Candidate.new
  end

  def new
    @candidate = @election.candidates.new
  end

  def create
    @candidate = @election.candidates.new(candidate_params)
    if @candidate.save
      redirect_to admin_election_candidates_path(@election), notice: 'Candidate added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @candidate.update(candidate_params)
      redirect_to admin_election_candidates_path(@election), notice: 'Candidate updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @candidate.destroy
    redirect_to admin_election_candidates_path(@election), notice: 'Candidate deleted.'
  end

  private

  def set_election
    @election = Election.find(params[:election_id])
  end

  def set_candidate
    @candidate = @election.candidates.find(params[:id])
  end

  def candidate_params
    params.require(:candidate).permit(:name)
  end

  def ensure_admin
    unless current_user.is_admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
