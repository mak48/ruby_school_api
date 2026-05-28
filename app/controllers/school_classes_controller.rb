class SchoolClassesController < ApplicationController
  def index
    school = School.find_by(id: params[:school_id])
    unless school
      render json: { error: 'School not found' }, status: :not_found
      return
    end

    classes = school.school_classes.map do |c|
      {
        id: c.id,
        number: c.number,
        letter: c.letter,
        students_count: c.students_count
      }
    end

    render json: { data: classes }
  end

  def students
    school = School.find_by(id: params[:school_id])
    unless school
      render json: { error: 'School not found' }, status: :not_found
      return
    end

    school_class = school.school_classes.find_by(id: params[:class_id])
    unless school_class
      render json: { error: 'Class not found' }, status: :not_found
      return
    end

    students = school_class.students.map do |s|
      {
        id: s.id,
        first_name: s.first_name,
        last_name: s.last_name,
        surname: s.surname,
        class_id: s.school_class_id,
        school_id: s.school_id
      }
    end

    render json: { data: students }
  end
end