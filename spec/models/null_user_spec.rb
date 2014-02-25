require_relative '../../app/models/null_user'

describe NullUser do

  describe 'Instance Methods' do
    before do
      @null_user = NullUser.new
    end

    describe '#id' do
      it 'returns nil' do
        @null_user.id.should == nil
      end
    end

    describe '#name' do
      it 'returns nil' do
        @null_user.name.should == nil
      end
    end

    describe '#password' do
      it 'returns nil' do
        @null_user.password.should == nil
      end
    end

    describe '#authenticate' do
      it 'returns nil' do
        @null_user.authenticate('password').should == false
      end
    end
  end

end
