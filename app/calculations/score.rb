class Score < Patterns::Calculation

  private

  def result
    result = []
    begin
      match.game_sets.pluck(:score).compact.each do |score|
        score_length = score.length

        if score_length == 2
          result << "#{score.first.to_i}:#{score.last.to_i}"
        elsif score_length != 0
          raise '?'
        end
      end
    rescue => e
      return e.message
    end

    return '-' if result.empty?
    result.compact.join(' ')
  end

  def match
    subject
  end
end
