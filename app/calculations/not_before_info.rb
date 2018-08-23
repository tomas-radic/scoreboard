class NotBeforeInfo < Patterns::Calculation

  private

  def result
    return '' if !match.scheduled? || match.finished?
    match.not_before.strftime('%k:%M')
  end

  def match
    subject
  end
end
