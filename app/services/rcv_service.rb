class RcvService
  # Usage: RcvService.new(election).calculate
  attr_reader :election, :rounds, :winner, :eliminated_order, :ballot_weights

  def initialize(election)
    @election = election
    @rounds = []
    @eliminated_order = []
    @winner = nil
    @ballot_weights = {}
  end

  def calculate
    # Setup
    candidates = election.candidates.to_a
    ballots = election.ballots.includes(:ballot_items, :user)
    ballot_rankings = ballots.map { |ballot| [ballot, ballot.ballot_items.order(:rank).map(&:candidate_id)] }
    active_candidates = candidates.map(&:id)
    # Calculate vote weights for each ballot (user)
    @ballot_weights = {}
    ballots.each do |ballot|
      user = ballot.user
      weight = 1 + user.all_delegators.count
      @ballot_weights[ballot.id] = weight
    end
    total_votes = @ballot_weights.values.sum
    round_num = 1

    while active_candidates.size > 1
      tally = Hash.new(0)
      ballot_rankings.each do |ballot, ranking|
        # Find the highest-ranked active candidate
        vote = ranking.find { |cid| active_candidates.include?(cid) }
        weight = @ballot_weights[ballot.id] || 1
        tally[vote] += weight if vote
      end
      round_result = active_candidates.map do |cid|
        {
          candidate_id: cid,
          candidate_name: candidates.find { |c| c.id == cid }.name,
          votes: tally[cid] || 0
        }
      end
      @rounds << { round: round_num, results: round_result }

      # Check for majority
      round_result.each do |res|
        if res[:votes] > total_votes / 2.0
          @winner = res[:candidate_id]
          return self
        end
      end

      # Eliminate candidate(s) with fewest votes
      min_votes = round_result.map { |r| r[:votes] }.min
      eliminated = round_result.select { |r| r[:votes] == min_votes }.map { |r| r[:candidate_id] }
      @eliminated_order << eliminated
      active_candidates -= eliminated
      round_num += 1
    end

    # If only one remains, they win
    if active_candidates.size == 1
      @winner = active_candidates.first
    end
    self
  end
end 