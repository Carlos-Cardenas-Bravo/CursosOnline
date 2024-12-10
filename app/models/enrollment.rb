class Enrollment < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :course

  validates :progress, numericality: { only_integer: true, in: 0..100 }
end
