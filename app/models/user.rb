class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_secure_password

  validates :name, presence: true, uniqueness: { case_sensitive: true }

  def increment_sign_in_count!
    self.sign_in_count += 1
    self.save!
  end

  def first_login?
    self.sign_in_count == 1
  end

end
