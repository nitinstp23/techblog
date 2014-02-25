class PostsController < ApplicationController

  before_action :authenticate, except: [:index, :show]

  def index
    @posts = Post.recent.page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to posts_url, notice: 'New Post Created'
    else
      render :new
    end
  end

  def show
    @post = Post.find_by(slug: params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
