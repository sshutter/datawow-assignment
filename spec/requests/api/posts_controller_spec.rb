require "rails_helper"

RSpec.describe Api::V1::User::PostsController, type: :request do
  let!(:user) { Fabricate(:user) }

  let(:post_attributes) { Fabricate.attributes_for(:post, user: user) }

  before(:each) do
    user.generate_auth_token
    user.save
  end

  ### Create ###
  describe 'POST /api/v1/user/posts' do
    context 'given valid attributes' do
      it 'response with created status' do
        post '/api/v1/user/posts', 
        params: { post: post_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }
        
        expect(response).to have_http_status :created
      end

      it 'response with expected json schema' do
        post '/api/v1/user/posts', 
        params: { post: post_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('post')
      end

      it 'should create a post' do
        post '/api/v1/user/posts', 
        params: { post: post_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(Post.count).to eq(1)
      end
    end

    context 'given invalid attributes' do
      it 'response with bad request status' do
        post '/api/v1/user/posts', 
        params: { post: post_attributes.except(:title) }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :bad_request
      end

      it 'response with expected json schema' do
        post '/api/v1/user/posts', 
        params: { post: post_attributes.except(:title) }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('errors')
      end

      it 'should not create a post' do
        post '/api/v1/user/posts', 
        params: { post: post_attributes.except(:title) }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(Post.count).to eq(0)
      end

      it 'should response with unauthorized status' do
        post '/api/v1/user/posts', 
        params: { post: post_attributes }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  ### Get current user all posts ###
  describe 'GET /api/v1/user/posts' do
    context 'given valid attributes' do
      it 'response with ok status' do
        get '/api/v1/user/posts', headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :ok
      end

      it 'response with expected json schema' do
        get '/api/v1/user/posts', headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('posts')
      end
    end

    context 'given invalid attributes' do
      it 'response with unauthorized status' do
        get '/api/v1/user/posts', headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  ### Get current user single post ###
  describe 'GET /api/v1/user/posts/:id' do
    let!(:post) { Fabricate(:post, user: user) }

    context 'given valid attributes' do
      it 'response with ok status' do
        get "/api/v1/user/posts/#{post.id}", headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :ok
      end

      it 'response with expected json schema' do
        get "/api/v1/user/posts/#{post.id}", headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('post')
      end
    end

    context 'given invalid attributes' do
      it 'response with unauthorized status' do
        get '/api/v1/user/posts', headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  ### Update ###
  describe 'PUT /api/v1/user/posts/:id' do
    let!(:post) { Fabricate(:post, user: user) }

    context 'given valid attributes' do
      it 'response with ok status' do
        put "/api/v1/user/posts/#{post.id}", 
        params: { post: { title: "New Title" } }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :ok
      end

      it 'response with expected json schema' do
        put "/api/v1/user/posts/#{post.id}", 
        params: { post: { title: "New Title" } }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('post')
      end

      it 'should update the post' do
        put "/api/v1/user/posts/#{post.id}", 
        params: { post: { title: "New Title" } }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        post.reload
        expect(post.title).to eq("New Title")
      end
    end

    context 'given invalid attributes' do
      it 'response with bad request status' do
        put "/api/v1/user/posts/#{post.id}", 
        params: { post: { title: "" } }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :bad_request
      end

      it 'response with expected json schema' do
        put "/api/v1/user/posts/#{post.id}", 
        params: { post: { title: "" } }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('errors')
      end

      it 'should not update the post' do
        put "/api/v1/user/posts/#{post.id}", 
        params: { post: { title: "" } }.to_json,
        headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        post.reload
        expect(post.title).to_not eq("")
      end

      it 'response with unauthorized status' do
        put "/api/v1/user/posts/#{post.id}", 
        params: { post: { title: "New Title" } }.to_json,
        headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  ### Delete ###
  describe 'DELETE /api/v1/user/posts/:id' do
    context 'given valid attributes' do
      let!(:post) { Fabricate(:post, user: user) }

      it 'response with ok status' do
        delete "/api/v1/user/posts/#{post.id}", headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :ok
      end

      it 'should delete the post' do
        delete "/api/v1/user/posts/#{post.id}", headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(Post.count).to eq(0)
      end
    end

    context 'given invalid attributes' do
      let!(:post) { Fabricate(:post, user: user) }

      it 'response with unauthorized status' do
        delete "/api/v1/user/posts/#{post.id}", headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  ### Get all user posts ###
  describe 'GET /api/v1/user/all_posts' do
    context 'given valid attributes' do
      it 'response with ok status' do
        get '/api/v1/user/all_posts', headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :ok
      end

      it 'response with expected json schema' do
        get '/api/v1/user/all_posts', headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('posts')
      end

      it 'should allow any users to view all posts' do
        get '/api/v1/user/all_posts', headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status :ok
      end
    end
  end

  ### Get any single post ###
  describe 'GET /api/v1/user/all_posts/:id' do
    let!(:post) { Fabricate(:post, user: user) }

    context 'given valid attributes' do
      it 'response with ok status' do
        get "/api/v1/user/all_posts/#{post.id}", headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to have_http_status :ok
      end

      it 'response with expected json schema' do
        get "/api/v1/user/all_posts/#{post.id}", headers: { 'Content-Type' => 'application/json', 'auth-token' => user.jwt }

        expect(response).to match_response_schema('single_post')
      end
      it 'should allow any users to view a post' do
        get '/api/v1/user/all_posts', headers: { 'Content-Type' => 'application/json' }
  
        expect(response).to have_http_status :ok
      end
    end
  end
end