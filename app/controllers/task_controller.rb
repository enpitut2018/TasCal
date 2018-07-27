# coding: utf-8
class TaskController < ApplicationController
  @err_flag = false

  def is_valid_date year, month, day, hour, minute
    if Date.valid_date?(year,month,day) then
      begin
        parsed_time = Time.parse(hour.to_s + ":" + minute.to_s) 
        return true
      rescue ArgumentError => e
        return false
      end
    else
      return false
    end
  end

  def insert
    if request.post? then
      name = params['name']
      year = params['year']
      month = params['month']
      day = params['day']
      hour = params['hour']
      minute = params['minute']
      elements = [name, year, month, day, hour, minute]
      if (elements.all? {|t| !t.empty? && !t.nil?}) && is_valid_date(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i) then
       Task.new(:name => name, :deadline => Time.zone.local(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)).save
       @err_flag = false
       #redirect_to :action =>"display"
     else
      @err_flag = true
      render nothing: true, status: 400
    end
  end

end

def display
  @err_flag = false
  @tasks = Task.all
  # p @tasks
end

def delete
  id = params['id']
  object = Task.find(id)
  if !object.nil? then
    object.destroy
    @err_flag = false
  end
  #redirect_to :action =>"display"
  redirect_to :action =>"insert"
end

def self.calc_available_time id, current_time=nil
    # 今の時間の取得
    if !current_time.nil?
      now = current_time
    else
      now = Time.zone.now
    end
    # deadlineの取得
    taskdata = Task.find(id.to_i)
    deadline = taskdata.deadline
    available_time = deadline - now
    # p available_time.class
    # p available_time
    
    # 予定が入っている時間を引く
    schedules = Schedule.all
    p schedules
    schedules.each do |schedule| 
      if schedule.start_time < deadline && schedule.end_time > now then
        if schedule.start_time >= now then
          if schedule.end_time < deadline then
            available_time -= (schedule.end_time - schedule.start_time)
          elsif schedule.end_time >= deadline then
            available_time -= (deadline - schedule.start_time)
          end
        elsif schedule.start_time < now then
          if schedule.end_time <= deadline then  
            available_time -= (schedule.end_time - now)
          elsif schedule.end_time > deadline then
            available_time = 0.0
          end
        end
      end
    end

      # if schedule.start_time > now && schedule.end_time < deadline then
      #   available_time -= (schedule.end_time - schedule.start_time)
      # elsif schedule.start_time > now && schedule.end_time > deadline then
      #   available_time -= (deadline - schedule.start_time)
      # elsif schedule.start_time < now && schedule.end_time < deadline then
      #   available_time -= (schedule.end_time - now)
      # elsif schedule.start_time < now && schedule.end_time > deadline then
      #   available_time = 0
      # end

    remaining_time = available_time / 60
    # schedule_list = ScheduleController.display
    # (diff/60).to_s + "時間" + (diff%60).to_s + "分"
    remaining_time
  end

end
