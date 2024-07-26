# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  auth_token             :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :text             not null
#  last_name              :text             not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_auth_token            (auth_token)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
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

  # Test interactions with database
  describe 'Database interactions' do
    context 'when a valid user is created' do
      it 'should be saved' do
        user.save
        expect(User.last).to eql(user)
      end
    end

    context 'when a user is destroyed' do
      it 'should be removed from the database' do
        user.save
        user.destroy
        expect(User.count).to eql(0)
      end
    end

  end
end
