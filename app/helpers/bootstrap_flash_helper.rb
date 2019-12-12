module BootstrapFlashHelper
  ALERT_TYPES = [:default, :primary, :success, :info, :warning, :danger].freeze unless
    const_defined?(:ALERT_TYPES)

  # Used from Twitter Bootstrap Rails gem
  # https://github.com/seyhunak/twitter-bootstrap-rails/blob/master/app/helpers/bootstrap_flash_helper.rb
  # rubocop: disable Metrics/AbcSize
  def bootstrap_flash(options={})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      case type
      when :notice
        type = :success
      when :alert, :error
        type = :danger
      end
      next unless ALERT_TYPES.include?(type)

      tag_options = { class: "alert alert-dismissible alert-#{type} fade-in" }.merge(options)
      close_button = tag.button(raw("&times;"), type: "button", class: "close",
                                                "data-dismiss": "alert", "aria-label": "close")

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, tag_options)
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
  # rubocop: enable Metrics/AbcSize
end
