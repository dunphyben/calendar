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
         "\tE - Existing Events",
         "\tX - Exit"
    choice = gets.chomp.upcase
    case choice
    when 'C'
      create_event
      gets
    when 'E'
      existing_events
    when 'X'
    else
      puts "Invalid input"
    end
  end
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
      gets
    when 'W'
      list_weeks_events
      gets
    when 'M'
      list_months_events
      gets
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
  # event_list = Event.all.each.sort_by { |event| event.start_time }
  counter = 0
  loop do
    Event.all.order("start_time").each do |event|
      if event.start_time.mday == Time.now.mday+counter && event.start_time.year == Time.now.year+counter
        puts "\n\nEvent Name: " + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "\n\n", "-"*40
      end
    end
    puts "N - Next day's events",
         "P - Previous day's events",
         "X - Back to menu"
    choice = gets.chomp.upcase
    case choice
    when "N"
      counter += 1
    when "P"
      counter -= 1
    when "X"
      break
    else
      puts "Invalid input"
    end

    puts "Press Enter to continue."
  end
end





def list_weeks_events
  puts "\n\n", "*"*40, "This Week's Events", "_"*30
  # event_list = Event.all.each.sort_by { |event| event.start_time }

  Event.all.order("start_time").each do |event|
    if event.start_time.to_date.cweek == Time.now.to_date.cweek && event.start_time.year == Time.now.year
      puts "\n\nEvent Name: " + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "\n\n", "-"*40
    end
  end
  puts "Press Enter to continue."
end

def list_months_events
  puts "\n\n", "*"*40, "This Month's Events", "_"*30
  # event_list = Event.all.each.sort_by { |event| event.start_time }

  Event.all.order("start_time").each do |event|
    if event.start_time.mon == Time.now.mon && event.start_time.year == Time.now.year
      puts "\n\nEvent Name: " + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "\n\n", "-"*40
    end
  end
  puts "Press Enter to continue."
end
# Now, create a view that lets users choose to only view events on the current day, week, or month.



welcome
