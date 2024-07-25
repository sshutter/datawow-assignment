require('rails_helper')

RSpec.describe User, type: :model do
  let(:user) { described_class.new( first_name: 'John', last_name: 'Doe', email: 'john@gmail.com', password: '12341234' ) }

  # Test validations
  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a first_name' do
      user.first_name = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a last_name' do
      user.last_name = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).to_not be_valid
    end
  end

  # Test Associations
  describe 'Associations' do
    it { should have_many(:posts) }
  end

  # Test Methods
  describe 'Methods' do
    context 'when called .generate_auth_token' do
      it 'should generate an auth_token' do
        auth_token = user.generate_auth_token
        expect(auth_token).to be_present
      end
    end

    context 'when called .jwt' do
      it 'should return a JWT' do
        jwt = user.jwt
        expect(jwt).to be_present
      end    
    end

    context 'when called .as_json_with_jwt' do
      it 'should return a JSON with JWT' do
        json = subject.as_json_with_jwt

        json_with_jwt = {
          email: subject.email,
          first_name: subject.first_name,
          last_name: subject.last_name,
          auth_jwt: subject.jwt
        }
        expect(json).to eql(json_with_jwt)
      end
    end

    context 'when called .as_profile_json' do
      it 'should return a JSON for his profile' do
        json = subject.as_profile_json

        profile = {
          email: subject.email,
          first_name: subject.first_name,
          last_name: subject.last_name
        }
        expect(json).to eql(profile)
      end
    end
  end
end