require 'syntax_highlighter'

class Post < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :title, :body, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  scope :recent, -> { order('created_at DESC') }

  before_validation :generate_slug, if: 'title.present?'
  before_save :highlight_syntax, if: 'body.present?'

  paginates_per 10

  def brief
    self.body[0..200]
  end

  def to_param
    self.slug
  end

  private

  def highlighter
    Techblog::SyntaxHighlighter.new(text: self.body)
  end

  def highlight_syntax
    self.body = highlighter.to_s
  end

  def generate_slug
    self.slug = self.title.parameterize
  end
end
