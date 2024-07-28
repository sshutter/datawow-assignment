class Api::V1::User::PostsController < Api::V1::User::AppController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :set_current_user_from_header, only: [:posts, :post]

  # Get all posts
  # 
  # Access: Public
  #
  # Request:
  # GET /api/v1/user/all_posts
  #
  # Response:
  # {
  #   "success": true,
  #   "posts": [
  #     {
  #       "id": 1,
  #       "title": "Post Title 1",
  #       "body": "Post body text 1",
  #       "user_id": 1,
  #       "created_at": "2024-07-27T12:34:56.000Z",
  #       "updated_at": "2024-07-27T12:34:56.000Z"
  #     },
  #     ...
  #   ],
  #   "count": 10
  # }
  def posts
    posts = Post.all
    render json: { success: true, posts: posts.as_json, count: posts.count }
  end
  
  # Get single post
  # 
  # Access: Public
  #
  # Request:
  # GET /api/v1/user/all_posts/1
  #
  # Response:
  # {
  #     "success": true,
  #     "post": {
  #         "id": 1,
  #         "title": "Post 2 by John",
  #         "body": "Body of Post 2 by John",
  #         "user_id": 1,
  #         "created_at": "2024-07-26T22:49:17.433Z",
  #         "updated_at": "2024-07-26T22:49:17.433Z"
  #     },
  #     "user": {
  #       "id": 1,
  #       "email": "john@gmail.com",
  #       "first_name": "John",
  #       "last_name": "Doe"
  #     }
  # }
  def post
    post = Post.find(params[:id])
    user = User.find(post.user_id)
    user_json = {}
    user_json[:id] = user.id
    user_json[:email] = user.email
    user_json[:first_name] = user.first_name
    user_json[:last_name] = user.last_name
    render json: { success: true, post: post.as_json, user: user_json }
  end

  # Get current user's posts
  # 
  # Access: Private
  #
  # Request:
  # GET /api/v1/user/posts
  # 
  # Headers:
  # {
  #   "Content-Type": "application/json",
  #   "auth-token": "Bearer <access-token>"
  # }
  #
  # Response:
  # {
  #   "success": true,
  #   "posts": [
  #     {
  #       "id": 1,
  #       "title": "User's Post Title",
  #       "body": "User's post body text",
  #       "user_id": 1,
  #       "created_at": "2024-07-27T12:34:56.000Z",
  #       "updated_at": "2024-07-27T12:34:56.000Z"
  #     },
  #     ...
  #   ]
  # }
  def index
    posts = current_user.posts
    render json: { success: true, posts: posts.as_json }
  end
  
  # Create a new post
  # 
  # Access: Private
  #
  # Request:
  # POST /api/v1/user/posts
  # 
  # Headers:
  # {
  #   "Content-Type": "application/json",
  #   "auth-token": "Bearer <access-token>"
  # }
  # 
  # Body:
  # {
  #   "post": {
  #     "title": "New Post Title",
  #     "body": "New post body text"
  #   }
  # }
  #
  # Response:
  # {
  #   "success": true,
  #   "post": {
  #     "id": 1,
  #     "title": "New Post Title",
  #     "body": "New post body text",
  #     "user_id": 1,
  #     "created_at": "2024-07-27T12:34:56.000Z",
  #     "updated_at": "2024-07-27T12:34:56.000Z"
  #   }
  # }
  def create
    post = Post.new(params_for_create)
    post.user_id = current_user.id
    raise MyError.new("Post creation failed: #{post.errors.full_messages.join(', ')}") if !post.save
    render  json: { success: true, post: post.as_json }, status: :created 
  end

  # Get a post for the current user
  #
  # Access: Private
  #
  # Request:
  # GET /api/v1/user/posts/1
  # 
  # Headers:
  # { 
  #   "Content-Type": "application/json",
  #   "auth-token": "Bearer <access-token>"
  # }
  #
  # Response:
  # {
  #   "success": true,
  #   "post": {
  #     "id": 1,
  #     "title": "Post Title 1",
  #     "body": "Post body text 1",
  #     "user_id": 1,
  #     "created_at": "2024-07-27T12:34:56.000Z",
  #     "updated_at": "2024-07-27T12:34:56.000Z"
  #   }
  # }
  # 
  # Errors:
  # - 404 Not Found: Post not found
  def show
    render json: { success: true, post: @post.as_json }
  end

  # Update a post
  #
  # Access: Private
  #
  # Request:
  # PUT /api/v1/user/posts/1
  # 
  # Headers:
  # {
  #   "Content-Type": "application/json",
  #   "auth-token": "Bearer <access-token>"
  # }
  # 
  # Body:
  # {
  #   "post": {
  #     "title": "Updated Post Title",
  #     "body": "Updated post body text"
  #   }
  # }
  #
  # Response:
  # {
  #   "success": true,
  #   "post": {
  #     "user_id": 1,
  #     "title": "Updated Post Title",
  #     "body": "Updated post body text",
  #     "id": 1,
  #     "created_at": "2024-07-27T12:34:56.000Z",
  #     "updated_at": "2024-07-27T12:45:00.000Z"
  #   }
  # }
  # 
  # Errors:
  # - 400 Bad Request: Post update failed ...
  # - 404 Not Found: Post not found
  def update
    if @post.update(params_for_update)
      render json: { success: true, post: @post.as_json }
    else
      raise MyError.new("Post update failed: #{@post.errors.full_messages.join(', ')}") 
    end
  end

  # Delete a post
  #
  # Access: Private
  #
  # Request:
  # DELETE /api/v1/user/posts/1
  # Headers:
  # { 
  #   "Content-Type": "application/json",
  #   "auth-token": "Bearer <access-token>"
  # }
  #
  # Response:
  # {
  #   "success": true
  # }
  # 
  # Errors:
  # - 404 Not Found: Post not found
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
