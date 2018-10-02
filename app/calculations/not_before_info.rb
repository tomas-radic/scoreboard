class NotBeforeInfo < Patterns::Calculation

  private

  def result
    return '' if match.not_before.blank? || match.started?
    match.not_before.strftime('%k:%M')
  end

  def match
    subject
  end
end
