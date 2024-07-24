class Api::AppController < ApplicationController
    rescue_from MyError, with: :handle_400
    rescue_from MyAuthenticationError, with: :handle_401
    rescue_from JWT::VerificationError, with: :handle_401
    rescue_from JWT::ExpiredSignature, with: :handle_401
    rescue_from JWT::DecodeError, with: :handle_401 
    rescue_from ActiveRecord::RecordNotFound, with: :handle_404
    rescue_from ActionController::ParameterMissing, with: :handle_400

    def handle_400(exception)
        render json: { success: false, error: exception.message }, status: 400 and return
    end

    def handle_401(exception)
        render json: { success: false, error: exception.message }, status: 401 and return
    end

    def handle_404(exception)
        message = exception.message.split("[").first.strip
        render json: { success: false, error: message }, status: 404 and return
    end
end
