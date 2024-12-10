class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :check_student, only: %i[new create]
  before_action :authorize_student_or_instructor, only: %i[show]
  before_action :authorize_student, only: %i[edit update destroy]

  # GET /enrollments
  def index
    if current_user.estudiante?
      # Estudiantes solo ven sus inscripciones
      @enrollments = current_user.enrollments
    elsif current_user.instructor?
      # Instructores ven inscripciones de sus cursos
      @enrollments = Enrollment.joins(:course).where(courses: { instructor_id: current_user.id })
    else
      @enrollments = Enrollment.none # Usuarios no autorizados
    end
  end

  # GET /enrollments/1
  def show
    # Acción protegida por `authorize_student_or_instructor`
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # POST /enrollments
  def create
    @enrollment = current_user.enrollments.build(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to @enrollment, notice: "Inscripción creada exitosamente." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /enrollments/1/edit
  def edit
    # Acción protegida por `authorize_student`
  end

  # PATCH/PUT /enrollments/1
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: "Inscripción actualizada exitosamente." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1
  def destroy
    @enrollment.destroy!

    respond_to do |format|
      format.html { redirect_to enrollments_path, status: :see_other, notice: "Inscripción eliminada exitosamente." }
      format.json { head :no_content }
    end
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def check_student
    redirect_to root_path, alert: "Acceso denegado." unless current_user.estudiante?
  end

  def authorize_student_or_instructor
    # Permitir acceso si el estudiante es el propietario o el instructor del curso
    unless current_user.estudiante? && @enrollment.student == current_user ||
           current_user.instructor? && @enrollment.course.instructor == current_user
      redirect_to root_path, alert: "No tienes permiso para acceder a esta inscripción."
    end
  end

  def authorize_student
    # Solo el estudiante propietario puede editar, actualizar o eliminar su inscripción
    redirect_to root_path, alert: "No tienes permiso para realizar esta acción." unless @enrollment.student == current_user
  end

  def enrollment_params
    params.require(:enrollment).permit(:course_id, :progress)
  end
end