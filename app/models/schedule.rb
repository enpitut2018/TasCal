class Schedule < ApplicationRecord
  def self.createRecord name, start_time, end_time, user_id
    Schedule.create(:user_id => user_id, :name => name, :start_time => start_time, :end_time => end_time)
  end
  def self.include? s, time
    s.start_time < time && time < s.end_time
  end
  def self.destroyRecord id
    object = Schedule.find(id)
    if !object.nil? then
      object.destroy
    end
  end
end
