class Api::V1::User::PostsController < Api::V1::User::AppController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :set_current_user_from_header, only: [:posts, :post]

  # Get all posts
  # GET /api/v1/user/posts
  # Access Public
  def posts
    posts = Post.all
    render json: { success: true, posts: posts.as_json, count: posts.count }
  end
  
  # Get single post
  # GET /api/v1/user/posts/:id
  # Access Public
  def post
    post = Post.find(params[:id])
    render json: { success: true, post: post.as_json }
  end

  # Get currents user's posts
  # GET /api/v1/user/posts
  # Access Private
  def index
    posts = current_user.posts
    render json: { success: true, posts: posts.as_json }
  end
  
  # Create a new post
  # POST /api/v1/user/posts
  # Access Private
  def create
    post = Post.new(params_for_create)
    post.user_id = current_user.id
    raise MyError.new("Post creation failed: #{post.errors.full_messages.join(', ')}") if !post.save
    render  json: { success: true, post: post.as_json }, status: :created 
  end

  # Get a post
  # GET /api/v1/user/posts/:id
  # Access Private
  def show
    render json: { success: true, post: @post.as_json }
  end

  # Update a post
  # PUT /api/v1/user/posts/:id
  # Access Private
  def update
    if @post.update(params_for_update)
      render json: { success: true, post: @post.as_json }
    else
      raise MyError.new("Post update failed: #{@post.errors.full_messages.join(', ')}") 
    end
  end

  # Delete a post
  # DELETE /api/v1/user/posts/:id
  # Access Private
  def destroy
    @post.destroy
    render json: { success: true }
  end

  private
  def params_for_create
    params.require(:post).permit(:title, :body)
  end

  def params_for_update
    params.require(:post).permit(:title, :body)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
