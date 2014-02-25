require 'spec_helper'

describe Session do

  it 'includes ActiveModel::ForbiddenAttributesProtection module' do
    Session.new.should be_kind_of(ActiveModel::ForbiddenAttributesProtection)
  end

  it 'includes ActiveModel::Model module' do
    Session.new.should be_kind_of(ActiveModel::Model)
  end

  it 'includes Rails.application.routes.url_helpers module' do
    Session.new.should be_kind_of(Rails.application.routes.url_helpers)
  end

  it 'extends Forwardable module' do
    Session.should be_kind_of(Forwardable)
  end

  describe 'Validations' do
    it 'fails if username is blank' do
      session = Session.new password: 'password'
      session.should have(1).error_on(:username)
    end

    it 'fails if password is blank' do
      session = Session.new username: 'nitin'
      session.should have(1).error_on(:password)
    end

    it 'fails if username or password is wrong' do
      user = create(:user)

      session1 = Session.new username: 'wrong_username', password: 'password'
      User.should_receive(:find_by).with({name: 'wrong_username'}).and_return(nil)

      session2 = Session.new username: 'nitin', password: 'wrong_password'
      User.should_receive(:find_by).with({name: 'nitin'}).and_return(user)

      session1.should have(1).error_on(:base)
      session2.should have(1).error_on(:base)
    end

    it 'passes with valid attributes' do
      user = create(:user)

      session = Session.new username: 'nitin', password: 'password'
      User.should_receive(:find_by).with({name: 'nitin'}).and_return(user)

      session.should be_valid
    end
  end

  describe 'Instance Methods' do

    describe '#initialize' do
      it 'assigns username and password' do
        session = Session.new username: 'nitin', password: 'password'

        session.username.should == 'nitin'
        session.password.should == 'password'
      end
    end

    describe '#valid?' do
      before do
        @user = create(:user)
        User.should_receive(:find_by).with({name: 'nitin'}).and_return(@user)
      end

      context 'with valid username and password' do
        it 'increments user sign_in_count and returns true' do
          session = Session.new username: 'nitin', password: 'password'

          @user.should_receive(:save!).and_return(nil)

          @user.sign_in_count.should == 0
          session.valid?.should == true
          @user.sign_in_count.should == 1
        end
      end

      context 'with invalid username or password' do
        it 'returns nil' do
          session = Session.new username: 'nitin', password: 'wrong_password'

          @user.sign_in_count.should == 0
          session.valid?.should == nil
          @user.sign_in_count.should == 0
        end
      end
    end

    describe '#user' do
      before do
        @user = create(:user)
      end

      context 'with valid username' do
        it 'returns user' do
          session = Session.new username: 'nitin', password: 'wrong_password'
          User.should_receive(:find_by).with({name: 'nitin'}).and_return(@user)

          session.user.should == @user
        end
      end

      context 'with invalid username' do
        it 'returns null user' do
          session = Session.new username: 'wrong_username', password: 'password'
          User.should_receive(:find_by).with({name: 'wrong_username'}).and_return(nil)

          session.user.should be_a NullUser
          session.user.id.should == nil
          session.user.name.should == nil
          session.user.password.should == nil
        end
      end
    end

    def redirect_url
      return root_url(only_path: true) unless user.first_login?
      edit_user_url(id: user.id, only_path: true)
    end

    describe 'redirect_url' do
      context 'user.first_login? = true' do
        it 'returns root_url' do
          user = double('user', id: 1, first_login?: true)

          session = Session.new username: 'nitin', password: 'password'
          session.stub(:user) { user }

          session.redirect_url.should == Rails.application.routes.url_helpers
                                              .edit_user_url(id: user.id, only_path: true)
        end
      end

      context 'user.first_login? = false' do
        it 'returns edit_user_url' do
          user = double('user', id: 1, first_login?: false)

          session = Session.new username: 'nitin', password: 'password'
          session.stub(:user) { user }

          session.redirect_url.should == Rails.application.routes.url_helpers
                                              .root_url(only_path: true)
        end
      end
    end

  end

end
