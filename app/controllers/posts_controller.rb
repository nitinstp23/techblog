class PostsController < ApplicationController

  def index
    @posts = Post.recent.page params[:page]
  end
end
