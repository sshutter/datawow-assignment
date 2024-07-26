require "rails_helper"

RSpec.describe Api::V1::User::SessionsController, type: :request do
  # Create a user and get attributes
  let(:user_attributes) { Fabricate.attributes_for(:user) }

  ### Register ###
  describe 'POST /api/v1/user/register' do
    let(:register_attributes) { user_attributes }

    context 'given valid attributes' do
      it 'response with created status' do
        post '/api/v1/user/register', 
        params: { user: register_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json' }
        
        expect(response).to have_http_status :created
      end

      it 'response with expected json schema' do
         post '/api/v1/user/register', 
        params: { user: register_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(response).to match_response_schema('users')
      end

      it 'should create a user' do
        post '/api/v1/user/register', 
        params: { user: register_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(User.count).to eq(1)
      end
    end

    context 'given invalid attributes' do
      it 'response with unprocessable entity status' do
        post '/api/v1/user/register', 
        params: { user: register_attributes.except(:password) }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :bad_request
      end

      it 'response with expected json schema' do
        post '/api/v1/user/register', 
        params: { user: register_attributes.except(:password) }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(response).to match_response_schema('errors')
      end

      it 'should not create a user' do
        post '/api/v1/user/register', 
        params: { user: register_attributes.except(:password) }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(User.count).to eq(0)
      end
    end
  end

  ### Sign in ###
  describe 'POST /api/v1/user/sign_in' do
    # Create a user
    let!(:user) { Fabricate(:user) }
    
    let(:sign_in_attributes) { user_attributes.except(:first_name, :last_name) }

    context 'given valid attributes' do
      it 'response with ok status' do
        post '/api/v1/user/sign_in',
        params: { user: sign_in_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json' }
        
        expect(response).to have_http_status :ok
      end

      it 'should return with expected json schema' do
        post '/api/v1/user/sign_in',
        params: { user: sign_in_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(response).to match_response_schema('users_with_jwt')
      end
    end

    context 'given invalid attributes' do
      it 'response with unauthorized status' do
        post '/api/v1/user/sign_in',
        params: { user: sign_in_attributes.except(:email) }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :bad_request
      end
    end
  end

  ### Sign out ###
  describe 'DELETE /api/v1/user/sign_out' do
    let!(:user) { Fabricate(:user) }

    before(:each) do
      user.generate_auth_token
      user.save
    end

    let(:auth_jwt) { user.jwt }

    context 'given valid attributes' do
      it 'response with ok status' do
        delete '/api/v1/user/sign_out',
        headers: { 'Content-Type' => "application/json", 'auth-token' => "Bearer #{user.jwt}" }

        expect(response).to have_http_status :ok
      end

      it 'should changed the auth_token' do
        old_auth_token = user.auth_token
        delete '/api/v1/user/sign_out',
        headers: { 'Content-Type' => "application/json", 'auth-token' => "Bearer #{user.jwt}" }

        user.reload
        expect(user.auth_token).to_not eq(old_auth_token)
      end
    end

    context 'given invalid attributes' do
      it 'response with unauthorized status' do
        delete '/api/v1/user/sign_out',
        headers: { 'Authorization' => 'invalid_jwt' }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  ### Me ###
  describe 'GET /api/v1/user/me' do
    let!(:user) { Fabricate(:user) }

    before(:each) do
      user.generate_auth_token
      user.save
    end

    let(:auth_jwt) { user.jwt }

    context 'given valid attributes' do
      it 'response with ok status' do
        get '/api/v1/user/me',
        headers: { 'Content-Type' => "application/json", 'auth-token' => "Bearer #{user.jwt}" }
        
        expect(response).to have_http_status :ok
      end

      it 'should return with expected json schema' do
        get '/api/v1/user/me',
        headers: { 'Content-Type' => "application/json", 'auth-token' => "Bearer #{user.jwt}" }

        expect(response).to match_response_schema('users')
      end

      it 'should return the current user' do
        get '/api/v1/user/me',
        headers: { 'Content-Type' => "application/json", 'auth-token' => "Bearer #{user.jwt}" }

        json_response = JSON.parse(response.body)
        email = json_response['user']['email']
        first_name = json_response['user']['first_name']
        last_name = json_response['user']['last_name']
        
        expect(email).to eq(user.email)
        expect(first_name).to eq(user.first_name)
        expect(last_name).to eq(user.last_name)
      end
    end

    context 'given invalid attributes' do
      it 'response with unauthorized status' do
        get '/api/v1/user/me',
        headers: { 'Authorization' => 'invalid_jwt' }

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end