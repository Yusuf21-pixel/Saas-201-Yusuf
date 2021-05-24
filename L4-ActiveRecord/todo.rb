require "active_record"

class Todo < ActiveRecord::Base
  def self.overdue
    where("due_date < ?", Date.today)
  end

  def self.due_today
    where("due_date = ?", Date.today)
  end

  def self.due_later
    where("due_date > ?", Date.today)
  end

  # This function takes an array of Todo and convert it as a printable string
  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }.join("\n")
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = (Date.today == due_date) ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    # array of todos received after calling the class method overdue it is sent as a parameter to to_displayable_list it will return a printable string.
    puts overdue.to_displayable_list
    puts "\n\n"

    puts "Due Today\n"
    puts due_today.to_displayable_list
    puts "\n\n"

    puts "Due Later\n"
    puts due_later.to_displayable_list
    puts "\n\n"
  end

  def self.add_task(todo)
    # Recieved a hash containing todo_text and due_in_days with these data it creates a new todo and inserts in the table and returns the todo object.
    create!(todo_text: todo[:todo_text], due_date: Date.today + todo[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    # find_by returns the object if a record is present with the given id otherwise It will return nil.
    todo = find_by(id: todo_id)
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
