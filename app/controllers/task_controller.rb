# coding: utf-8
class TaskController < ApplicationController
  @err_flag = false
  @err_id = "初期" #1:名前 2:日程 0:正常 -1:初期

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
      elements = [year, month, day, hour, minute]
      if (name.length <= 50 && name.length > 0) then 
        if (elements.all? {|t| !t.empty? && !t.nil?}) && is_valid_date(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i) then
      
          Task.new(:name => name, :deadline => Time.zone.local(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)).save
          @err_id = "正常"          # 正常に追加
        #redirect_to :action =>"display"
        else
          @err_id = "日程"          # 日程が異常
          render nothing: true, status: 400
        end
      else
        @err_id = "名前"        # 名前が0文字または50文字以上
      end
  end

end

def display
  @err_id = "初期"
  @tasks = Task.all
  # p @tasks
end

  @edit_id = 0
def delete
    if params['edit']
      begin
        @edit_id = params['edit']
        # redirect_to :action => "edit"
        exit
      rescue SystemExit
        puts "redirect error"
      end
    end
  id = params['id']
  object = Task.find(id)
  if !object.nil? then
    object.destroy
    @err_id = "初期"
  end
  #redirect_to :action =>"display"
  redirect_to :action =>"insert"
end

  # def edit
  # end

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
    if remaining_time < 0 then
      remaining_time = 0
    end
    # schedule_list = ScheduleController.display
    # (diff/60).to_s + "時間" + (diff%60).to_s + "分"
    remaining_time
  end
end
