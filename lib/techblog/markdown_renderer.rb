module Techblog
  class MarkdownRenderer < Redcarpet::Markdown

    def initialize(text)
      super(
        Redcarpet::Render::HTML.new(hard_wrap: true),
        no_intra_emphasis: true,
        autolink: true,
        fenced_code_blocks: true
      )

      @text = text
    end

    def render
      super(@text)
    end
  end

end
