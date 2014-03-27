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
    puts "\tC - Create an event.",
         "\tL - List All Events",
         "\tX - Exit"
    choice = gets.chomp.upcase
    case choice
    when 'C'
      create_event
    when 'L'
      list_events
    when 'X'
    else
      puts "Invalid input"
    end
  end
end

# Next, let users list out the events in the order in which they will occur. By default, only list events in the future.


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
  puts "Your event '#{description}' has been created!\n\n"

end

def list_events
  puts "LIST OF EVENTS\n\n"
  time = Time.now


  event_list = Event.all.each.sort_by { |event| event.start_time }

  event_list.each do |event|
    if event.end_time > time
      puts "Event Name: " + event.desc, "Location: " + event.location, "Start Time: " + event.start_time.to_s, "End Time: " + event.end_time.to_s, "-"*40
    end
  end
end

welcome
