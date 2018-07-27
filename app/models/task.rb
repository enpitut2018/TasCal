# coding: utf-8
class Task < ApplicationRecord
  def self.calc_deadtime id
    #締め切りまでの時間(min)
    task = Task.all.find(id)
    time = task.deadline - Time.zone.now
    time / 60
  end
  def self.calc_rate_busy id
    d_time = calc_deadtime(id)
    f_time = TaskController.calc_available_time id
    f_time / d_time
  end
  def self.busy_color id
    rate = calc_rate_busy id
    if rate <= 0.6 then
      "table-danger"
    elsif rate <= 0.8 then
      "table-warning"
    else
      ""
    end
  end
end
