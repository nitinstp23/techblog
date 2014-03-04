require 'redcarpet'
require 'nokogiri'
require 'webmock/rspec'

require_relative '../../../lib/techblog/syntax_highlighter'

describe Techblog::SyntaxHighlighter do

  def highlighted_text
    @highlighted_text ||= '<h2>Dummy Text</h2>'
  end

  def pygments_uri
    Techblog::SyntaxHighlighter::PYGMENTS_URI
  end

  def stub_pygments_api_call
    stub_request(:post, pygments_uri)
      .to_return(body: highlighted_text)
  end

  before do
    @syntax_highlighter = Techblog::SyntaxHighlighter.new(text: '## Dummy Text')
  end

  describe '#to_s' do
    it 'returns syntax highlighted text' do
      stub_pygments_api_call

      @syntax_highlighter.to_s.should == highlighted_text
    end
  end

  describe 'private methods' do
    describe '#pygments_uri' do
      it 'returns parsed uri' do
        @syntax_highlighter.send(:pygments_uri).should == URI.parse(pygments_uri)
      end
    end

    describe '#markdown_renderer' do
      it 'returns Redcarpet::Markdown instance' do
        @syntax_highlighter.send(:markdown_renderer)
          .should be_an_instance_of(Redcarpet::Markdown)
      end
    end

    describe '#call_pygments_api' do
      context 'request successful' do
        it 'returns response from pygments api' do
          stub_pygments_api_call

          response = @syntax_highlighter.send(:call_pygments_api, '', '')

          response.response.should be_kind_of(Net::HTTPOK)
          response.body.should   == highlighted_text
        end
      end

      context 'request failed' do
        it 'handles exception and re-raises it' do
          stub_request(:post, pygments_uri).to_raise(StandardError.new('Connection Error'))

          lambda {
            @syntax_highlighter.send(:call_pygments_api, '', '')
          }.should raise_error(StandardError, 'Error occurred while calling Pygments API : Connection Error')
        end
      end
    end

    describe '#build_html_doc' do
      it 'builds html_doc' do
        @syntax_highlighter.send(:markdown_renderer)
          .stub(:render) { highlighted_text }

        @syntax_highlighter.send(:build_html_doc)

        @syntax_highlighter.instance_variable_get(:@html_doc)
          .should be_an_instance_of(Nokogiri::HTML::Document)
      end
    end
  end

end
