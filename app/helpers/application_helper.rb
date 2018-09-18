module ApplicationHelper
  def switch_locale_link(current_url)
    current_locale = I18n.locale.to_s
    switch_to_locale = case current_locale
    when 'en'
      'sk'
    when 'sk'
      'en'
    end

    url_splitted = current_url.split('/')
    url_splitted.find { |e| e == I18n.locale.to_s }.gsub!(current_locale, switch_to_locale)
    link_to t('switch_locale_label'), url_splitted.join('/'), class: 'nav-link'
  end
end
