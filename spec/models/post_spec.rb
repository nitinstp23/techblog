require 'spec_helper'

describe Post do
  before do
    @post = Post.create(title: 'My First Blog Post', body: 'Dummy Text')
  end

  it "is valid" do
    @post.should be_valid
  end  
end
