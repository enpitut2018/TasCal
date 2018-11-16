# coding: utf-8
class Task < ApplicationRecord
  def self.calc_deadtime id
    #締め切りまでの時間(min)
    task = Task.all.find(id)
    time = task.deadline - Time.zone.now
    time / 60

    if time < 0
      time = 0
    end

    time
  end

  def self.calc_rate_busy id
    d_time = calc_deadtime(id)

    if d_time <= 0
      1
    else
      f_time = TaskController.calc_available_time id
      f_time / d_time
    end
  end

  def self.createRecord name, deadline, user_id=nil
    Task.create(:user_id => user_id, :name => name, :deadline => deadline)
  end

  def self.destroyRecord id
    object = Task.find(id)
    if !object.nil? then
      object.destroy
    end
  end
end
