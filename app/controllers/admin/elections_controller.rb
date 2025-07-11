class Admin::ElectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_election, only: [:edit, :update, :destroy]

  def index
    @elections = Election.order(starts_at: :desc)
  end

  def new
    @election = Election.new
  end

  def create
    @election = Election.new(election_params)
    if @election.save
      redirect_to admin_elections_path, notice: 'Election created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @election.update(election_params)
      redirect_to admin_elections_path, notice: 'Election updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @election.destroy
    redirect_to admin_elections_path, notice: 'Election deleted.'
  end

  private

  def set_election
    @election = Election.find(params[:id])
  end

  def election_params
    params.require(:election).permit(:title, :description, :starts_at, :ends_at)
  end

  def ensure_admin
    unless current_user.is_admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
