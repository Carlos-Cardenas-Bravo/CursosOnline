# Limpieza de datos existentes
puts "Eliminando datos existentes..."
Enrollment.destroy_all
Course.destroy_all
User.destroy_all

# Creación de usuarios (instructores y estudiantes)
puts "Creando usuarios..."
instructors = []
5.times do |i|
  instructors << User.create!(
    email: "instructor#{i + 1}@example.com",
    password: "password123",
    nombre: "Instructor#{i + 1}",
    apellido: "Apellido#{i + 1}",
    role: "instructor",
    edad: rand(30..50), # Edad aleatoria entre 30 y 50
    sexo: %w[Hombre Mujer].sample, # Sexo aleatorio
    receive_updates: [true, false].sample # Valor booleano aleatorio
  )
end

students = []
10.times do |i|
  students << User.create!(
    email: "student#{i + 1}@example.com",
    password: "password123",
    nombre: "Estudiante#{i + 1}",
    apellido: "Apellido#{i + 1}",
    role: "estudiante",
    edad: rand(18..25), # Edad aleatoria entre 18 y 25
    sexo: %w[Hombre Mujer].sample, # Sexo aleatorio
    receive_updates: [true, false].sample # Valor booleano aleatorio
  )
end

puts "Usuarios creados: #{User.count}"

# Creación de cursos asociados a instructores
puts "Creando cursos..."
instructors.each do |instructor|
  3.times do |i|
    Course.create!(
      title: "Curso #{i + 1} de #{instructor.nombre}",
      description: "Este es el Curso #{i + 1}, creado por #{instructor.nombre}.",
      duration: rand(10..50),
      instructor: instructor
    )
  end
end

puts "Cursos creados: #{Course.count}"

# Creación de inscripciones para estudiantes
puts "Creando inscripciones..."
students.each do |student|
  # Inscribir a cada estudiante en 2 cursos aleatorios
  Course.order("RANDOM()").limit(2).each do |course|
    Enrollment.create!(
      student: student,
      course: course,
      progress: rand(0..100)
    )
  end
end

puts "Inscripciones creadas: #{Enrollment.count}"

puts "Seed completado exitosamente."

