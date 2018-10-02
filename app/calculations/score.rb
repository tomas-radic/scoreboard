class Score < Patterns::Calculation

  private

  def result
    result = []
    begin
      match.game_sets.pluck(:score).compact.each do |score|
        score_length = score.length
        raise '?' if (score_length != 2 && score_length != 0)
        next if score.all?(&:blank?)
        result << "#{score.first.to_i}:#{score.last.to_i}"
      end
    rescue => e
      return e.message
    end

    return '-' if result.empty?
    result.compact.join(', ')
  end

  def match
    subject
  end
end
