module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    # sentence = I18n.t("errors.messages.not_saved",
    #                   :count => resource.errors.count,
    #                   :resource => resource.class.model_name.human.downcase)

    fragment = resource.errors.count == 1 ? "error is" : "errors are"

    html = <<-HTML
    <div class="alert alert-danger alert_msg">
      <p> The following #{fragment} preventing to proceed:</p>
      <ul class="regis_alert">#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

end