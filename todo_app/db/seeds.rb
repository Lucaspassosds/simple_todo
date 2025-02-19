Task.destroy_all

tasks = [
  {
    title: "Complete the coding challenge",
    description: "Finish building the Rails Task application",
    completed: false
  },
  {
    title: "Create documentation",
    description: "Document the implementation details and how to run the application",
    completed: false
  },
  {
    title: "Deploy the application",
    description: "Deploy the completed application to a hosting service",
    completed: false
  },
  {
    title: "Set up the development environment",
    description: "Install Ruby, Rails, and SQLite",
    completed: true
  }
]

tasks.each do |task|
  Task.create!(task)
end

puts "Created #{Task.count} tasks"