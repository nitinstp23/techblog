require 'spec_helper'

describe User do

  it 'includes ActiveModel::ForbiddenAttributesProtection module' do
    User.new.should be_kind_of(ActiveModel::ForbiddenAttributesProtection)
  end

  describe 'Validations' do
    it 'fails if name is blank' do
      user = User.new
      user.should have(1).error_on(:name)
    end

    it 'fails if name is not unique' do
      user1 = User.create(name: 'nitin', password: 'password', password_confirmation: 'password')
      user2 = User.create(name: 'nitin', password: 'password', password_confirmation: 'password')

      user1.should have(:no).errors_on(:name)
      user2.should have(1).error_on(:name)
    end

    it 'fails if password is blank' do
      user = User.new(name: 'nitin')
      user.should have(1).errors_on(:password)
    end

    it 'fails if password_confirmation is blank' do
      user = User.new(name: 'nitin', password: 'password')
      user.should have(1).errors_on(:password_confirmation)
    end

    it 'passes with valid attributes' do
      user = User.new(name: 'nitin', password: 'password', password_confirmation: 'password')
      user.should be_valid
    end
  end

  describe 'Instance Methods' do
    describe '#increment_sign_in_count!' do
      it 'increments sign_in_count by 1' do
        user = User.new(name: 'nitin', password: 'password', password_confirmation: 'password')

        user.should_receive(:save!).and_return(nil)

        user.send(:increment_sign_in_count!).should == nil
        user.sign_in_count.should == 1
      end
    end

    describe '#first_login?' do
      it 'returns true is sign_in_count is 1' do
        user = User.new(name: 'nitin', password: 'password', password_confirmation: 'password')
        user.sign_in_count = 1

        user.send(:first_login?).should == true
      end

      it 'returns false is sign_in_count is not 1' do
        user = User.new(name: 'nitin', password: 'password', password_confirmation: 'password')
        user.sign_in_count = 2

        user.send(:first_login?).should == false
      end
    end
  end
end
