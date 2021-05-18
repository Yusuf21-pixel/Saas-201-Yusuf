require "active_record"

class Todo < ActiveRecord::Base
  def is_overdue?
    due_date < Date.today
  end

  def is_due_today?
    due_date == Date.today
  end

  def is_due_later?
    due_date > Date.today
  end

  def self.overdue
    Todo.all.filter { |todo| todo.is_overdue? }
  end

  def self.due_today
    Todo.all.filter { |todo| todo.is_due_today? }
  end

  def self.due_later
    Todo.all.filter { |todo| todo.is_due_later? }
  end

  # This function takes a array of Todo and convert it as a printable string
  def self.to_displayable_list(todos)
    todos.map { |todo| todo.to_displayable_string }.join("\n")
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = (self.is_due_today?) ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    # array of todos recieved after calling the class method overdue it is sent as a parameter to to_displayable_list it will return a printable string.
    puts Todo.to_displayable_list(Todo.overdue)
    puts "\n\n"

    puts "Due Today\n"
    puts Todo.to_displayable_list(Todo.due_today)
    puts "\n\n"

    puts "Due Later\n"
    puts Todo.to_displayable_list(Todo.due_later)
    puts "\n\n"
  end

  def self.add_task(todo)
    # Recieved a hash containing todo_text and due_in_days with these data it creates a new todo and inserts in the database and returns the todo object.
    Todo.create!(todo_text: todo[:todo_text], due_date: Date.today + todo[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    # find_by returns the object if a record is present with the given id otherwise It will return nil.
    todo = Todo.find_by(id: todo_id)
    if todo.nil?
      puts "Invalid id #{todo_id} does not exist..."
      exit
    else
      todo.completed = true
      todo.save
      todo
    end
  end
end
