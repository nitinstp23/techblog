require 'uri'
require 'net/http'

module Techblog
  class SyntaxHighlighter

    def initialize(text: '')
      html = parse_to_html(text)
      @doc = Nokogiri::HTML(html)

      highlight_code_fragments
    end

    def to_s
      Redcarpet::Render::SmartyPants.render(
        @doc.search('//body').children.to_s
      )
    end

    private

    def pygments_uri
      @pygments_uri ||= URI.parse('http://pygments.appspot.com/')
    end

    def parse_to_html(text)
      markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(hard_wrap: true),
        no_intra_emphasis: true,
        autolink: true,
        fenced_code_blocks: true
      )
      markdown.render(text)
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

    def highlight_code_fragments
      @doc.search('pre > code[class]').each do |code|
        response = call_pygments_api(code[:class], code.text)

        code.parent.replace(response.body)
      end
    end

  end
end
