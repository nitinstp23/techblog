require 'forwardable'

class Session
  include ActiveModel::ForbiddenAttributesProtection
  include ActiveModel::Model
  include Rails.application.routes.url_helpers
  extend Forwardable

  attr_accessor :username, :password

  validates :username, :password, presence: true
  validate :user_authenticity

  def_delegator :user, :id, :user_id

  def initialize(attributes = {})
    attributes.each do |key, val|
      self.public_send("#{key}=", val.to_s)
    end
  end

  def valid?
    if super
      user.increment_sign_in_count!
      true
    end
  end

  def user
    @user ||= User.find_by(name: username) || NullUser.new
  end

  def redirect_url
    return root_url(only_path: true) unless user.first_login?
    edit_user_url(id: user.id, only_path: true)
  end

  private

  def user_authenticity
    unless user.authenticate(password)
      self.errors.add(:base, 'Invalid Username or Password')
    end
  end
end
