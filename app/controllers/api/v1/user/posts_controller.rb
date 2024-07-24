class Api::V1::User::PostsController < Api::V1::User::AppController
  before_action :set_post, only: [:show, :update, :destroy]

  # Get currents user's posts
  # GET /api/v1/user/posts
  def index
    posts = current_user.posts
    render json: { success: true, posts: posts.as_json }
  end
  
  # Get a single post
  # Get /api/v1/user/posts/:id
  def show
    render json: @post.as_json
  end

  # Create a new post
  # POST /api/v1/user/posts
  def create
    post = Post.new(params_for_create)
    post.user_id = current_user.id
    post.save
    render  json: { success: true, post: post.as_json } 
  end

  # Update a post
  # PUT /api/v1/user/posts/:id
  def update
    @post.update(params_for_update)
    render json: { success: true, post: @post.as_json }
  end

  # Delete a post
  # DELETE /api/v1/user/posts/:id
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
