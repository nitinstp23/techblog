require 'spec_helper'

describe PostsController do

  def signin
    user = create(:user)
    session[:user_id] = user.id
  end

  def create_params
    @create_params ||= {
      post: {
        title: 'Post Title',
        body: 'Post Body'
      }
    }
  end

  describe 'GET index' do
    it 'has 200 status code' do
      get :index
      response.code.should == '200'
    end

    it 'renders index template' do
      get :index
      response.should render_template(:index)
    end

    it 'assigns recent posts' do
      post1 = create(:post, title: 'Title 1')
      post2 = create(:post, title: 'Title 2')

      get :index
      assigns(:posts).should == [post2, post1]
    end
  end

  describe 'GET new' do
    before { signin }

    it 'has 200 status code' do
      get :new
      response.code.should == '200'
    end

    it 'renders new template' do
      get :new
      response.should render_template(:new)
    end

    it 'assigns a new post' do
      get :new

      assigns(:post).title.should      == nil
      assigns(:post).body.should       == nil
      assigns(:post).persisted?.should == false
    end
  end

  describe 'POST create' do
    before { signin }

    it 'has 302 status code' do
      post :create, create_params
      response.code.should == '302'
    end

    it 'redirects to index page' do
      post :create, create_params
      response.should redirect_to(action: :index)
    end

    context 'validation failure' do
      it 'renders new template' do
        create_params[:post][:title] = ''

        post :create, create_params
        response.should render_template(:new)
      end
    end

    it 'creates the post' do
      post :create, create_params

      post = Post.find_by(slug: 'post-title')

      assigns(:post).title.should      == post.title
      assigns(:post).body.should       == post.body
      assigns(:post).persisted?.should == true
    end
  end

  describe 'GET show' do
    it 'has 200 status code' do
      post = create(:post)

      get :show, { id: post.id }
      response.code.should == '200'
    end

    it 'render show template' do
      post = create(:post)

      get :show, { id: post.id }
      response.should render_template(:show)
    end

    it 'assigns post' do
      post = create(:post)

      get :show, { id: post.slug }

      assigns(:post).title.should == post.title
      assigns(:post).body.should  == post.body
    end
  end

end
