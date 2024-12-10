class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.instructor?
      @courses = current_user.courses # Cursos creados por el instructor
    elsif current_user.estudiante?
      @enrollments = current_user.enrollments # Inscripciones del estudiante
    end
  end
end
