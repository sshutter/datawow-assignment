class Api::V1::User::SessionsController < Api::V1::User::AppController
  def sign_in
    # params { user: { email: "email", password: "password" } }
    user = User.find_by_email(params[:user][:email])
    raise MyError.new("Invalid email") if user.blank?
    if user.valid_password?(params[:user][:password])
      render json: { success: true, user: user.as_json_with_jwt }
    else
      raise MyAuthenticationError.new("Invalid email or password")
    end
  end

  def sign_out
    current_user.generate_auth_token
    current_user.save
    render json: { success: true }
  end

  def me
    render json: { success: true, user: current_user.as_profile_json }
    return @current_user
  end

end
