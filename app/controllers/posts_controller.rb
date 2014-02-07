class PostsController < ApplicationController

  def index
    @posts = Post.recent
  end

  def show
    post_date = params[:year], params[:month], params[:day]
    @post = Post.where('date(created_at) = ?', post_date).where(title: params[:title])
  end
end
