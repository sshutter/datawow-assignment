class Api::V1::PostsController < ApplicationController

  # Get all posts
  # GET /api/v1/posts
  def all_posts
    posts = Post.all
    render json: { success: true, posts: posts.as_json }
  end
end
