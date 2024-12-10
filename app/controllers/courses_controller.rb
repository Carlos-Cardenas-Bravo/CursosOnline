class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy progress]
  before_action :authenticate_user!
  before_action :check_instructor, only: %i[new create edit update destroy analytics]
  before_action :authorize_instructor, only: %i[edit update destroy]

  # Acción para la analítica de cursos
  def analytics
    @courses = current_user.courses
  end

  # Acción para ver el progreso en un curso
  def progress
    if current_user.estudiante?
      @enrollment = current_user.enrollments.find_by(course_id: @course.id)

      if @enrollment
        @progress = @enrollment.progress
      else
        redirect_to courses_path, alert: "No estás inscrito en este curso."
      end
    else
      redirect_to root_path, alert: "Acceso denegado."
    end
  end

  # GET /courses
  def index
    if current_user.instructor?
      @courses = current_user.courses
    elsif current_user.estudiante?
      @courses = Course.all
    else
      @courses = Course.none
    end
  end

  # GET /courses/1
  def show; end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit; end

  # POST /courses
  def create
    @course = current_user.courses.build(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Curso creado exitosamente." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Curso actualizado exitosamente." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  def destroy
    if @course.instructor == current_user
      @course.destroy!
      respond_to do |format|
        format.html { redirect_to courses_path, status: :see_other, notice: "Curso eliminado exitosamente." }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, alert: "No tienes permiso para eliminar este curso."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find_by(id: params[:id])
    redirect_to courses_path, alert: "El curso no existe." if @course.nil?
  end

  def check_instructor
    redirect_to root_path, alert: "Acceso denegado." unless current_user.instructor?
  end

  def authorize_instructor
    redirect_to root_path, alert: "No tienes permiso para realizar esta acción." unless @course.instructor == current_user
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:title, :description, :duration)
  end
end

