class Schedule < ApplicationRecord
  def self.createRecord name, start_time, end_time
    Schedule.create(:name => name, :start_time => start_time, :end_time => end_time)
  end

  def self.destroyRecord id
    object = Schedule.find(id)
    if !object.nil? then
      object.destroy
    end
  end
end
