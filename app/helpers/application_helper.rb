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
end
