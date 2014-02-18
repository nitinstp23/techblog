module ApplicationHelper

  def avatar_url
    gravatar_id = Digest::MD5.hexdigest('nitin.misra23@gmail.com')
    "http://gravatar.com/avatar/#{gravatar_id}.png/?s=160"
  end

  def github_url
    'http://github.com/nitinstp23'
  end

  def twitter_url
    'http://twitter.com/nitinstp23'
  end

  def linkedin_url
    'http://www.linkedin.com/profile/view?id=174543476'
  end

  def mailto_url
    'mailto:nitin.misra23@gmail.com'
  end

  def company_url
    'http://www.rsystems.com/'
  end

  def error_messages_for(record, field_name)
    return if record.blank? || record.errors[field_name].blank?

    raw(
      record.errors[field_name].collect do |error_message|
        error_message = "#{field_name.to_s.humanize} #{error_message.to_s}"
        content_tag :span, error_message, class: 'help-inline'
      end.join
    )
  end

  def signout_link
    return unless signed_in?

    str = content_tag :li, '', class: 'divider'
    str += content_tag :li do
      link_to signout_sessions_url do
        content_tag :i, 'Sign out', class: 'fa fa-sign-out'
      end
    end

    raw(str)
  end
end
