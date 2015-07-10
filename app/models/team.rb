class Team < ActiveRecord::Base

  has_many :home_matches, foreign_key: :team1_id, class_name: 'Match'
  has_many :away_matches, foreign_key: :team2_id, class_name: 'Match'

  attr_accessor :nese


  def tour(week)
    @ctour = week
  end

  def stats week

    tour = week ? week : 6

    result = [{'matches' => 0,'points' => 0, 'win' => 0, 'draw' => 0, 'lost' => 0, 'goal_forward' => 0, 'goal_against' => 0, 'average' => 0, 'prediction' => 0}]

    home_matches.where("week <= :week", {week: tour}).each do |match|
      result.push(result.last.merge(match_result(match.team1_score, match.team2_score)){|key, old_result, new_result| new_result + old_result})
    end

    away_matches.where("week <= :week", {week: tour}).each do |match|
      result.push(result.last.merge(match_result(match.team2_score, match.team1_score)){|key, old_result, new_result| new_result + old_result})
    end

    result.last
  end

  def all_matches
    home_matches.length + away_matches.length
  end

  private
    def score(score1, score2)
      if score1 > score2
        3
      elsif score1 < score2
        0
      else
        1
      end
    end

  private
    def match_result(score1, score2)
      points = score(score1, score2)
      win = score1 > score2 ? 1 : 0
      draw = score1 == score2 ? 1 : 0
      lost = score1 < score2 ? 1 : 0
      average = score1 - score2
      {'matches' => 1, 'points' => points, 'win' => win, 'draw' => draw, 'lost' => lost, 'goal_forward' => score1, 'goal_against' => score2, 'average' => average}
    end
end
