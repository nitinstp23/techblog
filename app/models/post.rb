class Post < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :title, :body, presence: true

  scope :recent, -> { order('created_at DESC') }

  before_save :highlight_syntax, if: 'body.present?'
  before_save :generate_slug

  paginates_per 10

  def brief
    self.body[0..200]
  end

  def to_param
    self.slug
  end

  private

  def highlighter
    SyntaxHighlighter.new(text: self.body)
  end

  def highlight_syntax
    self.body = highlighter.to_s
  end

  def generate_slug
    self.slug = self.title.downcase.gsub(/\s/, '-')
  end
end
