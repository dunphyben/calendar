require 'spec_helper'
describe Note do
  it "should belong to event and task" do
    event = Event.create
    task = Task.create
    event_note = Note.new({ :name => 'this is the event note', :notable_id => event.id, :notable_type => 'Event' })
    task_note= Note.new({ :name => 'this is the task note', :notable_id => task.id, :notable_type => 'Task' })
    # event.notes.first.should eq event_note
    # task.notes.first.should eq task_note
    event_note.notable.should eq event
    task_note.notable.should eq task
  end
end
