class Post < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :comments

  validates :title, :body, presence: true

  scope :recent, -> { order('created_at DESC') }

  before_save :highlight_syntax, if: 'body.present?'

  def brief
    body[0..200]
  end

  private

  def highlight_syntax
    self.body = SyntaxHighlighter.new(text: self.body).to_s
  end
end
