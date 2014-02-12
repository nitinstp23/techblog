class PostsController < ApplicationController

  def index
    @posts = Post.recent
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to posts_url, notice: 'New Post Created !'
    else
      render :new
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
