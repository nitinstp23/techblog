require 'spec_helper'

describe Post do

  it 'includes ActiveModel::ForbiddenAttributesProtection module' do
    Post.new.should be_kind_of(ActiveModel::ForbiddenAttributesProtection)
  end

  describe 'Validations' do
    it 'fails if title is blank' do
      post = Post.new body: 'Dummy Text'
      post.should have(1).error_on(:title)
    end

    it 'fails if body is blank' do
      post = Post.new title: 'Test Title'
      post.should have(1).error_on(:body)
    end

    it 'fails if slug is not unique' do
      post1 = Post.create title: 'Test Title', body: 'Dummy Text'
      post2 = Post.create title: 'Test Title', body: 'Dummy Text'

      post1.should have(:no).error_on(:slug)
      post2.should have(1).error_on(:slug)
    end

    it 'passes with valid attributes' do
      post = create(:post)
      post.should be_valid
    end
  end

  describe 'Instance Methods' do
    describe '#brief' do
      it 'returns first 200 chars of body' do
        post = create(:post, body: ('txt' * 200))
        post.brief.should == post.body[0..200]
      end
    end

    describe '#to_param' do
      it 'returns parameterized title' do
        post = create(:post)

        post.to_param
        post.slug.should == 'test-title'
      end
    end

    describe '#highlighter' do
      it 'returns instance of SyntaxHighlighter' do
        post = create(:post)

        Techblog::SyntaxHighlighter.should_receive(:new).with({text: post.body}).and_return('highlighter')
        post.send(:highlighter).should == 'highlighter'
      end
    end

    describe '#highlight_syntax' do
      it 'sets body to highlighted text returned from highlighter' do
        post = create(:post)

        highlighter = double('highlighter', to_s: 'Syntax Highlighted Body')
        post.stub(:highlighter) { highlighter }

        post.send(:highlight_syntax)
        post.body.should == highlighter.to_s
      end
    end

    describe '#generate_slug' do
      it 'sets body to highlighted text returned from highlighter' do
        post = create(:post)

        post.send(:generate_slug)
        post.slug.should == 'test-title'
      end
    end
  end
end
