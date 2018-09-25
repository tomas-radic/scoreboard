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
    url_locale = url_splitted.find { |e| e == I18n.locale.to_s }
    link_url = nil

    if url_locale.present?
      url_locale.gsub!(current_locale, switch_to_locale)
      link_url = url_splitted.join('/')
    else
      link_url = root_path(locale: switch_to_locale)
    end

    link_to t('switch_locale_label'), link_url, class: 'nav-link'
  end

  def add_error_class_to(class_attribute, obj, attribute_to_check)
    class_attribute += ' field-error' if obj.errors[attribute_to_check].present?
    class_attribute
  end
end
