# coding: utf-8
class Task < ApplicationRecord
  def self.calc_deadtime id
    #締め切りまでの時間(min)
    task = Task.all.find(id)
    time = task.deadline - Time.zone.now()
  end
  def self.calc_rate_busy id
    d_time = calc_deadtime id
    free_time = Task_controller.calc_available_time id
    free_time / d_time
  end
  def self.busy_color id
    rate = calc_rate_busy id
    if rate <= 0.5 then
      "#ff0000"
    elsif rate <= 0.7 then
      "#00ff00"
    else
      "#0000ff"
  end
end
