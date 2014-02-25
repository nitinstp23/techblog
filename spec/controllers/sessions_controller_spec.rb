require 'spec_helper'

describe SessionsController do

  def create_params
    @create_params ||= {
      session: {
        username: 'nitin',
        password: 'password'
      }
    }
  end

  describe 'GET new' do
    it 'has 200 status code' do
      get :new
      response.code.should == '200'
    end

    it 'renders new template' do
      get :new
      response.should render_template(:new)
    end

    it 'assigns a new user' do
      get :new

      assigns(:session).should_not be_nil
      assigns(:session).username.should be_nil
      assigns(:session).password.should be_nil
    end
  end

  describe 'POST create' do
    before do
      @user = create(:user)
    end

    it 'has 302 status code' do
      post :create, create_params
      response.code.should == '302'
    end

    context 'if user\'s first login' do
      it 'redirects to change password page' do
        post :create, create_params
        response.should redirect_to(edit_user_url(id: @user.id))
      end
    end

    context 'if not user\'s first login' do
      it 'redirects to root_url' do
        @user.increment_sign_in_count!

        post :create, create_params
        response.should redirect_to(root_url)
      end
    end

    context 'with incorrect credentials' do
      it 'renders new template' do
        create_params[:session][:password] = 'wrong-password'

        post :create, create_params
        response.should render_template(:new)
      end
    end

    it 'builds a session' do
      post :create, create_params

      assigns(:session).should_not be_nil
      assigns(:session).username.should == create_params[:session][:username]
      assigns(:session).password.should == create_params[:session][:password]
    end
  end

  describe 'DELETE destroy' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    it 'has 302 status code' do
      delete :destroy, { id: @user.id }
      response.code.should == '302'
    end

    it 'redirects to root_url' do
      delete :destroy, { id: @user.id }
      response.should redirect_to(root_url)
    end

    it 'destroys user session' do
      delete :destroy, { id: @user.id }

      session[:user_id].should be_nil
    end
  end

end
