module ApplicationHelper
  def switch_locale_link(current_url)
    current_locale = I18n.locale.to_s
    switch_to_locale = case current_locale
    when 'en'
      'sk'
    when 'sk'
      'en'
    end

    link_to t('switch_locale_label'), root_url(locale: switch_to_locale), class: 'nav-link'
  end

  def add_error_class_to(class_attribute, obj, attribute_to_check)
    class_attribute += ' field-error' if obj.errors[attribute_to_check].present?
    class_attribute
  end
end
