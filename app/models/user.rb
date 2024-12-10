# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  nombre                 :string
#  apellido               :string
#  role                   :integer          default("normal_user")
#  edad                   :integer
#  sexo                   :string
#  receive_updates        :boolean
#
# rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum para roles de usuario
  enum role: { estudiante: 0, instructor: 1 }

  # Active Storage para imágenes de perfil
  has_one_attached :profile_image

  # Relación con cursos como instructor
  has_many :courses, foreign_key: "instructor_id", dependent: :destroy
  has_many :enrollments, foreign_key: "student_id", dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course

  # Método para redimensionar la imagen de perfil
  def resized_profile_image
    if profile_image.attached?
      profile_image.variant(resize_to_limit: [200, 200]).processed
    else
      # Usa la imagen predeterminada y aplica el mismo redimensionamiento
      Rails.root.join("app/assets/images/default_profile.png").open do |file|
        variant = ActiveStorage::Blob.create_and_upload!(
          io: file,
          filename: "default_profile.png",
          content_type: "image/png"
        )
        variant.variant(resize_to_limit: [200, 200]).processed
      end
    end
  end

  # Validaciones
  validates :nombre, presence: true, length: { maximum: 50 }
  validates :apellido, presence: true, length: { maximum: 50 }
  validates :edad, numericality: { only_integer: true, greater_than: 0, less_than: 100 }, allow_nil: true
  validates :sexo, inclusion: { in: %w[Hombre Mujer], message: "%{value} no es un sexo válido" }, allow_nil: true

  # Callback para establecer rol predeterminado
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :normal_user
  end
end


# rubocop:enable Layout/SpaceInsideArrayLiteralBrackets
