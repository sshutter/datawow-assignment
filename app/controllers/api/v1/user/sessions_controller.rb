class Api::V1::User::SessionsController < Api::V1::User::AppController
  skip_before_action :set_current_user_from_header, only: [:sign_in, :register]

  # Sign In
  # POST /api/v1/user/sign_in
  # Params { user: { email: "email", password: "password" } }
  def sign_in
    user = User.find_by_email(params[:user][:email])
    raise MyError.new("Invalid email") if user.blank?
    if user.valid_password?(params[:user][:password])
      render json: { success: true, user: user.as_json_with_jwt }
    else
      raise MyAuthenticationError.new("Invalid email or password")
    end
  end

  # Sign Out
  # DELETE /api/v1/user/sign_out
  def sign_out
    current_user.generate_auth_token
    current_user.save
    render json: { success: true }
  end

  # Get current user profile
  # GET /api/v1/user/me
  def me
    render json: { success: true, user: current_user.as_profile_json }
    return @current_user
  end

  # Create User
  # POST /api/v1/user/register
  # Params { user: { email: "email", password: "password", first_name: "first_name", last_name: "last_name" } }
  def register
    user = User.new(params_for_register)
    user.save
    render json: { success: true, user: user }, status: 201
  end
  
  private
  def params_for_register
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end

end
