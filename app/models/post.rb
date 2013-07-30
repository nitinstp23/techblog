class Post < ActiveRecord::Base
  paginates_per 1

  scope :recent, order('created_at DESC')
end
