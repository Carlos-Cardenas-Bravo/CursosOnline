class Course < ApplicationRecord
  # Relación con el modelo User (como instructor)
  belongs_to :instructor, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :student

  # Validaciones
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
