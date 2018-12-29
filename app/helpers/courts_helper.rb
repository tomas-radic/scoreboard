module CourtsHelper
  def courts_switch_link_class(page_court, court)
    result = 'nav-link btn btn-sm'
    result += ' active btn-outline-success' if page_court.id == court.id
    result
  end
end
