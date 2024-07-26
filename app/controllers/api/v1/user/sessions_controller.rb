class Api::V1::User::SessionsController < Api::V1::User::AppController
  skip_before_action :set_current_user_from_header, only: [:sign_in, :register]

  # Sign In
  #
  # Access: Public
  #
  # Request:
  # POST /api/v1/user/sign_in
  # 
  # Body:
  # {
  #   "user": {
  #     "email": "user@example.com",
  #     "password": "password123"
  #   }
  # }
  #
  # Response:
  # {
  #   "success": true,
  #   "user": {
  #     "email": "user@example.com",
  #     "first_name": "John",
  #     "last_name": "Doe",
  #     "auth_token": "jwt-token-here"
  #   }
  # }
  #
  # Errors:
  # - 400 Bad Request: Invalid email or password
  # - 404 Not Found: Invalid email
  def sign_in
    user = User.find_by_email(params[:user][:email])
    raise ActiveRecord::RecordNotFound if user.blank?
    if user.valid_password?(params[:user][:password])
      render json: { success: true, user: user.as_json_with_jwt }
    else
      raise MyAuthenticationError.new("Invalid email or password")
    end
  end

  # Sign Out
  #
  # Access: Private
  #
  # Request:
  # DELETE /api/v1/user/sign_out
  # 
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
  # - 401 Unauthorized: Invalid or missing auth token
  def sign_out
    current_user.generate_auth_token
    current_user.save
    render json: { success: true }
  end

  # Get current user profile
  #
  # Access: Private
  #
  # Request:
  # GET /api/v1/user/me
  # Headers:
  # { 
  #   "Content-Type": "application/json",
  #   "auth-token": "Bearer <access-token>"
  # }
  #
  # Response:
  # {
  #   "success": true,
  #   "user": {
  #     "email": "user@example.com",
  #     "first_name": "John",
  #     "last_name": "Doe",
  #   }
  # }
  #
  # Errors:
  # - 401 Unauthorized: Invalid or missing auth token
  def me
    render json: { success: true, user: current_user.as_profile_json }
    return @current_user
  end

  # Create User
  #
  # Access: Public
  #
  # Request:
  # POST /api/v1/user/register
  # 
  # Body:
  # {
  #   "user": {
  #     "email": "newuser@example.com",
  #     "password": "password123",
  #     "first_name": "Jane",
  #     "last_name": "Doe"
  #   }
  # }
  #
  # Response:
  # {
  #   "success": true,
  #   "user": {
  #     "email": "newuser@example.com",
  #     "first_name": "Jane",
  #     "last_name": "Doe",
  #   }
  # }
  #
  # Errors:
  # - 400 Bad Request: User registration failed: <error-messages>
  def register
    user = User.new(params_for_register)
    raise MyError.new("User registration failed: #{user.errors.full_messages.join(', ')}") if !user.save
    render json: { success: true, user: user.as_profile_json }, status: 201
  end
  
  private
  def params_for_register
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end

end
