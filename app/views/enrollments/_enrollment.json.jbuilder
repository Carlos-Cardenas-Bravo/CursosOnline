json.extract! enrollment, :id, :student_id, :course_id, :progress, :created_at, :updated_at
json.url enrollment_url(enrollment, format: :json)
