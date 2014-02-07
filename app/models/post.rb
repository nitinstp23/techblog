class Post < ActiveRecord::Base
  has_many :comments

  scope :recent, -> { order('created_at DESC') }
end
