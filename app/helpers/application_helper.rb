module ApplicationHelper

  def avatar_url
    gravatar_id = Digest::MD5.hexdigest(Techblog::Info::EMAIL)
    "http://gravatar.com/avatar/#{gravatar_id}.png/?s=160"
  end

  def github_url
    Techblog::Info::GITHUB
  end

  def twitter_url
    Techblog::Info::TWITTER
  end

  def linkedin_url
    Techblog::Info::LINKEDIN
  end

  def mailto_url
    "mailto:#{Techblog::Info::EMAIL}"
  end

  def company_url
    Techblog::Info::COMPANY
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
      link_to session_path(session[:user_id]), method: :delete do
        content_tag :i, 'Sign out', class: 'fa fa-sign-out'
      end
    end

    raw(str)
  end
end
