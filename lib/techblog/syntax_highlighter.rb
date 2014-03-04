require 'uri'
require 'net/http'

module Techblog
  class SyntaxHighlighter

    PYGMENTS_URI = 'http://pygments.appspot.com/'

    def initialize(text: '')
      @text = text
    end

    def to_s
      build_html_doc
      highlight_code_fragments

      Redcarpet::Render::SmartyPants.render(
        @html_doc.search('//body').children.to_s
      )
    end

    private

    def pygments_uri
      @pygments_uri ||= URI.parse(PYGMENTS_URI)
    end

    def markdown_renderer
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(hard_wrap: true),
        no_intra_emphasis: true,
        autolink: true,
        fenced_code_blocks: true
      )
    end

    def call_pygments_api(code_class, code_text)
      Net::HTTP.post_form(
        pygments_uri,
        'lang' => code_class.to_s,
        'code' => code_text.to_s.rstrip
      )
    rescue => ex
      raise StandardError, "Error occurred while calling Pygments API : #{ex.message}"
    end

    def build_html_doc
      html      = markdown_renderer.render(@text)
      @html_doc = Nokogiri::HTML(html)
    end

    def highlight_code_fragments
      @html_doc.search('pre > code[class]').each do |code|
        response = call_pygments_api(code[:class], code.text)

        code.parent.replace(response.body)
      end
    end

  end
end
