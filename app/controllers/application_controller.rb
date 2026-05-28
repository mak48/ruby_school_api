class ApplicationController < ActionController::API
  private

  SECRET_SALT = ENV.fetch('SECRET_SALT', 'default_dev_salt_change_in_production')

  def authenticate_student!
    student_id = params[:user_id]
    expected_token = Digest::SHA256.hexdigest("#{student_id}#{SECRET_SALT}")

    provided = request.headers['Authorization']&.sub(/\ABearer /, '')
    unless provided.present? && ActiveSupport::SecurityUtils.secure_compare(provided, expected_token)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def generate_token(student_id)
    Digest::SHA256.hexdigest("#{student_id}#{SECRET_SALT}")
  end
end