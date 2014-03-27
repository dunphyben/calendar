require 'active_record'
require 'pry'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])

def welcome
  puts "Welcome to the Calender!\n\n"
  main_menu
end

def main_menu
  choice = nil
  until choice == 'x'
    puts "C - Create an event."
    choice = gets.chomp.upcase
    case choice
    when 'C'
      create_event
    when 'X'
    else
      puts "Invalid input"
    end
  end
end

def create_event
  puts "*"*40, "\n\nCREATE NEW EVENT\n\n", "*"*40
  puts "Event Description: "
  description = gets.chomp
  puts "Location: "
  location = gets.chomp
  puts "Start Time: "
  start_time = gets.chomp
  puts "End Time: "
  end_time = gets.chomp
  new_event = Event.create(desc: description, location: location, start_time: start_time, end_time: end_time)
  puts "Your event '#{description}' has been created!\n\n"

end

welcome
