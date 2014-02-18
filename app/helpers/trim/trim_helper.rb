module Trim
  module TrimHelper

    #include Rails.application.routes.url_helpers

    def notice_and_alert_messages
      if flash.any?
        content_tag(:section, :class => 'messages') do
          out = ''

          flash.each do |key, msg|
            next if msg.blank?
            type = 'success' if key == :notice
            type = 'notice' if key == :message
            type = 'error' if key == :alert

            out += content_tag(:div, :class => type) do
              msg.kind_of?(Array) ? msg.join('<br/>').html_safe : msg
            end
          end

          out.html_safe
        end.html_safe
      end
    end

    def nav_has_children?
      defined?(@section) && @section.children.size > 0
    end

    def on_homepage?
      params[:action] == 'index' && params[:controller] == 'home'
    end

    def body_classes
      body_classes = [on_homepage? ? 'home' : 'internal']
      body_classes += ['logged-in', 'with-admin-bar'] if user_signed_in?
      body_classes.join(' ')
    end

    def first_or_last_classes_by_index(i, total_count)
      if i == 0
        'first'
      elsif (i == total_count - 1)
        'last'
      else
        ''
      end
    end

    def even_or_odd_classes_by_index(i)
      (i % 2 == 0) ? 'even' : 'odd'
    end
  end
end
