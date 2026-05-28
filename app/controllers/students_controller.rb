class StudentsController < ApplicationController
  before_action :authenticate_student!, only: [:destroy]

  def create
    student = Student.new(student_params)
    if student.save
      token = generate_token(student.id)
      response.headers['X-Auth-Token'] = token
      render json: student_json(student), status: :created
    else
      render json: { errors: student.errors.full_messages }, status: :method_not_allowed
    end
  end

  def destroy
    student = Student.find_by(id: params[:user_id])
    if student
      student.destroy
      head :no_content
    else
      render json: { error: 'Invalid student id' }, status: :bad_request
    end
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :surname, :class_id, :school_id)
  end

  def student_json(student)
    {
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      surname: student.surname,
      class_id: student.school_class_id,
      school_id: student.school_id
    }
  end
end