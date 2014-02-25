require 'spec_helper'

describe UsersController do

  def user
    @user ||= create(:user)
  end

  def signin
    session[:user_id] = user.id
  end

  def update_params
    @update_params ||= {
      id: user.id,
      user: {
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    }
  end

  before do
    signin
  end

  describe 'GET edit' do
    it 'has 200 status code' do
      get :edit, { id: user.id }
      response.code.should == '200'
    end

    it 'renders edit template' do
      get :edit, { id: user.id }
      response.should render_template(:edit)
    end

    it 'assigns a edit user' do
      get :edit, { id: user.id }
      assigns(:user).should == user
    end
  end

  describe 'PUT update' do
    it 'has 302 status code' do
      put :update, update_params
      response.code.should == '302'
    end

    it 'redirects to index page' do
      put :update, update_params
      response.should redirect_to(root_url)
    end

    context 'validation failure' do
      it 'renders edit template' do
        update_params[:user][:password_confirmation] = ''

        put :update, update_params
        response.should render_template(:edit)
      end
    end

    it 'updates the user' do
      put :update, update_params
      assigns(:user).should == user
    end
  end

end
