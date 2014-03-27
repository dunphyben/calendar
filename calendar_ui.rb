require 'active_record'
require 'pry'
require 'date'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])

def welcome
  puts "Welcome to the Calender!\n\n"
  main_menu
end

def main_menu
  choice = nil
  until choice == 'X'
    puts "*"*40, "MAIN MENU", "*"*40
    puts "\tC - Create an event.",
         "\tT - Create a task",
         "\tE - Existing Events",
         "\tL - List tasks",
         "\tX - Exit"
    choice = gets.chomp.upcase
    case choice
    when 'C'
      create_event
      gets
    when 'E'
      existing_events
    when 'T'
      create_task
    when 'L'
      list_tasks
    when 'X'
    else
      puts "Invalid input"
    end
  end
end

def create_task
  puts "*"*40, "\n\nCREATE NEW TASK\n\n", "*"*40
  puts "Task Name: "
  name = gets.chomp
  Task.create({desc: name})
end

def list_tasks
  Task.all.each_with_index do |task, index|
    # binding.pry
    puts "#{index+1}.  #{task.desc}", "-"*40
  end

  puts "N - Add a note to one of these tasks",
       "V - View notes on one of these tasks",
       "X - Back to main menu"
  input = gets.chomp.upcase
  case input
  when 'V'
    puts "Which task would you like to view the notes on?"
    chosen_note = gets.chomp.to_i
    view_notes(Task.all[chosen_note-1])
  when 'N'
    puts 'Which task would you like to add a note to?'
    chosen_note = gets.chomp.to_i
    add_note(Task.all[chosen_note-1])
  when 'X'
  else
    puts 'Invalid input'
  end
end

def view_notes(notable)
  # binding.pry
  if notable.notes.first != nil
    notable.notes.each do |notable|
      puts notable.name
    end
  else
    puts "This #{notable.class.to_s.downcase} has no notes."
  end
end

def add_note(notable)
  puts "Enter the note you wish to add"
  note = gets.chomp
  Note.create({name: note, notable_id: notable.id, notable_type: notable.class.to_s})
end

# Next, let users list out the events in the order in which they will occur. By default, only list events in the future.


def existing_events
  choice = nil
  until choice == 'X'
    puts "*"*40, "Existing Events\n", "*"*40
    puts "\tL: List all future events",
         "\tT: List all events for today",
         "\tW: List all events for this week",
         "\tM: List all events for this month",
         "\tX: Return to main menu"

    choice = gets.chomp.upcase
    case choice
    when 'L'
      list_future_events
      gets
    when 'T'
      list_todays_events
    when 'W'
      list_weeks_events
    when 'M'
      list_months_events
    when 'X'
    end
  end
end


def create_event
  puts "*"*40, "\n\nCREATE NEW EVENT\n\n", "*"*40
  puts "Event Description: "
  description = gets.chomp
  puts "Location: "
  location = gets.chomp
  puts "Start Day: "
  puts "Enter the Year"
  start_year = gets.chomp.to_i
  puts "Enter the month"
  start_month = gets.chomp.to_i
  puts "Enter the day"
  start_day = gets.chomp.to_i
  puts "Enter the hour"
  start_hour = gets.chomp.to_i
  start_time = DateTime.new(start_year, start_month, start_day, start_hour, 0, 0)
  puts "End Time: "
  puts "Enter the Year"
  end_year = gets.chomp.to_i
  puts "Enter the month"
  end_month = gets.chomp.to_i
  puts "Enter the day"
  end_day = gets.chomp.to_i
  puts "Enter the hour"
  end_hour = gets.chomp.to_i
  end_time = DateTime.new(end_year, end_month, end_day, end_hour, 0, 0)
  new_event = Event.create(desc: description, location: location, start_time: start_time, end_time: end_time)
  puts "\n\nYour event '#{description}' has been created!\n\n"
  puts "Press Enter to continue."

end


def list_future_events
  puts "\n\n", "^"*25, "LIST OF EVENTS", "-"*35, "\n\n"
  time = Time.now

  Event.all.order("start_time").each do |event|
    if event.end_time > time
      puts "\n\nEvent Name: " + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "\n\n", "-"*40
    end
  end
  puts "Press Enter to continue."

end



def list_todays_events

  puts "\n\n", "*"*40, "Today's Events", "_"*30
  time = Time.now
  loop do

    selected_events = Event.all.order("start_time").select{ |event| event.start_time.mday == time.mday && event.start_time.year == time.year && event.start_time.mon == time.mon}
    if selected_events.first == nil
      puts "\n\nNo events scheduled for today.\n\n"
    end
    selected_events.each_with_index do |event, index|
        puts "\n\n#{index + 1}: Event Name: "  + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "\n\n", "-"*40
    end
    puts "A - Add a note to an event",
         "V - View notes for an event",
         "N - Next day's events",
         "P - Previous day's events",
         "E - Edit an event",
         "D - Delete an event",
         "X - Back to menu"
    choice = gets.chomp.upcase
    case choice
    when "A"
      puts "Which event would you like to add a note to?"
      user_input = gets.chomp.to_i
      if user_input > 0
        add_note(selected_events[user_input-1])
      else
        puts 'Invalid input'
      end
    when "V"
      puts "Which event would you like to view the notes for?"
      chosen_event = gets.chomp.to_i
      system 'clear'
      puts "NOTES", "#{selected_events[chosen_event-1].desc}", "-"*25
      view_notes(selected_events[chosen_event-1])
      puts "Press enter to continue"
      gets
    when "N"
      system 'clear'
      time = time.to_date.next_day
    when "E"
      puts "Enter the number of the event you want to update"
      update_select = gets.chomp.to_i
      if update_select > 0
        edit_event(selected_events[update_select-1])
      else
        puts 'invalid input'
      end
    when "D"
      puts "Enter the number of the event you wish to delete: "
      user_choice = gets.chomp.to_i
      if user_choice > 0
        selected_events[user_choice-1].destroy
      else
        puts 'Invalid input'
      end
    when "P"
      system 'clear'
      time = time.to_date.prev_day
    when "X"
      break
    else
      puts "Invalid input"
    end
  end
end


def list_weeks_events
  puts "\n\n", "*"*40, "This Week's Events", "_"*30
  time = Time.now
  loop do

    selected_events = Event.all.order("start_time").select { |event| event.start_time.to_date.cweek == time.to_date.cweek && event.start_time.year == time.year }
    if selected_events.first == nil
      puts "\n\nNo events scheduled this week.\n\n"
    end
    selected_events.each_with_index do |event, index|
        puts "\n\n#{index + 1}: Event Name: " + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "\n\n", "-"*40
    end
    puts "A - Add a note to an event",
         "V - View notes for an event",
         "N - Next week's events",
         "P - Previous week's events",
         "E - Edit an event",
         "D - Delete an event",
         "X - Back to menu"
    choice = gets.chomp.upcase
    case choice

    when "A"
      puts "Which event would you like to add a note to?"
      user_input = gets.chomp.to_i
      add_note(selected_events[user_input-1])
    when "V"
      puts "NOTES", "Which event would you like to view notes for?"
      chosen_event = gets.chomp.to_i
      system 'clear'
      puts "#{selected_events[chosen_event-1].desc}", "-"*25
      view_notes(selected_events[chosen_event-1])
      puts "Press enter to continue"
      gets
    when "N"
      time = time.to_date.next_day.next_day.next_day.next_day.next_day.next_day.next_day
    when "P"
      time = time.to_date.prev_day.prev_day.prev_day.prev_day.prev_day.prev_day.prev_day
    when "E"
      puts "Enter the number of the event you want to update"
      update_select = gets.chomp.to_i
      edit_event(selected_events[update_select - 1])
    when "D"
      puts "Enter the number of the event you wish to delete: "
      user_choice = gets.chomp.to_i
      selected_events[user_choice-1].destroy
    when "X"
      break
    else
      puts "Invalid input"
    end
  end
end

def list_months_events
  puts "\n\n", "*"*40, "This Month's Events", "_"*30
  time = Time.now
  loop do

    selected_events = Event.all.order("start_time").select { |event| event.start_time.mon == time.mon && event.start_time.year == time.year }
    if selected_events.first == nil
      puts "\n\nNo events scheduled this month.\n\n"
    end
    selected_events.each_with_index do |event, index|
      puts "\n\n#{index + 1}: Event Name: " + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "\n\n", "-"*40
    end

    puts "A - Add a note to an event",
         "V - View notes for an event",
         "N - Next month's events",
         "P - Previous month's events",
         "E - Edit an event",
         "D - Delete an event",
         "X - Back to menu"
    choice = gets.chomp.upcase
    case choice
    when "A"
      puts "Which event would you like to add a note to?"
      user_input = gets.chomp.to_i
      add_note(selected_events[user_input-1])
    when "V"
      puts "Which event would you like to view the notes of?"
      chosen_event = gets.chomp.to_i
      system 'clear'
      puts "NOTES", "#{selected_events[chosen_event-1].desc}", "-"*25
      view_notes(selected_events[chosen_event-1])
      puts "Press enter to continue"
      gets

    when "N"
      time = time.to_date.next_month
    when "P"
      time = time.to_date.prev_month
    when "E"
      puts "Enter the number of the event you wish to update: "
      user_choice = gets.chomp.to_i
      edit_event(selected_events[user_choice-1])
    when "D"
      puts "Enter the number of the event you wish to delete: "
      user_choice = gets.chomp.to_i
      selected_events[user_choice-1].destroy
    when "X"
      break
    else
      puts "Invalid input"
    end
    puts "Press Enter to continue."
  end
end

def edit_event(event)
  puts "What would you like to update?",
       "N - Name",
       "L - Location",
       "S - Start time",
       "E - End time",
       "X - Go back"
  choice = gets.chomp.upcase
  case choice
  when 'N'
    puts "Please enter a new name"
    name = gets.chomp
    event.update({ desc: name})
  when 'L'
    puts "Please enter a new location"
    location = gets.chomp
    event.update({ location: location})
  when 'S'
    puts "Start Day: "
    puts "Enter the Year"
    start_year = gets.chomp.to_i
    puts "Enter the month"
    start_month = gets.chomp.to_i
    puts "Enter the day"
    start_day = gets.chomp.to_i
    puts "Enter the hour"
    start_hour = gets.chomp.to_i
    start_time = DateTime.new(start_year, start_month, start_day, start_hour, 0, 0)
    event.update({ start_time: start_time})
  when 'E'
    puts "End Time: "
    puts "Enter the Year"
    end_year = gets.chomp.to_i
    puts "Enter the month"
    end_month = gets.chomp.to_i
    puts "Enter the day"
    end_day = gets.chomp.to_i
    puts "Enter the hour"
    end_hour = gets.chomp.to_i
    end_time = DateTime.new(end_year, end_month, end_day, end_hour, 0, 0)
    event.update({ end_time: end_time})
  when 'X'
  else
    puts "Invalid option. Please try again."
    edit_event(event)
  end
end



welcome
