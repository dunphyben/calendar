class Event < ActiveRecord::Base
  has_many :notes, as: :notable
end
