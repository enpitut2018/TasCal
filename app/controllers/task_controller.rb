# coding: utf-8
class TaskController < ApplicationController
  @err_flag = false
  @err_id = "初期" #1:名前 2:日程 0:正常 -1:初期
  @@edit_id #編集対象データのID一時保存用

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
        if (elements.all? {|t| !t.blank?}) && is_valid_date(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i) then
          deadline = Time.zone.local(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)

          if view_context.user_signed_in? then
            Task.createRecord(name, deadline, current_user.email)
          else
            Task.createRecord(name, deadline)
          end

          @err_id = "タスク正常"          # 正常に追加
        else
          @err_id = "日程"          # 日程が異常
          render nothing: true, status: 400
        end
      else
        @err_id = "タスク名前"        # 名前が0文字または50文字以上
      end
    end
  end

  def display
    @err_id = "初期"

    if view_context.user_signed_in? then
      @tasks = Task.where(user_id: current_user.email)
    else
      @tasks = Task.all
    end

  end

  def delete
    if params['edit'] then
      begin
        @@edit_id = params['edit']
        redirect_to :action => "edit"
        exit
      rescue SystemExit
        puts "Edit"
      end
    else
      id = params['id']
      Task.destroyRecord(id)
      @err_id = "初期"
      redirect_to :action => "insert"
    end
  end

  def self.getEditTaskName
    t = Task.find(@@edit_id)
    t.name
  end

  def self.getEditTaskDeadline
    t = Task.find(@@edit_id)
    t.deadline
  end

  def edit
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
          deadline = Time.zone.local(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)
          Task.createRecord(name, deadline, Task.find_by_id(@@edit_id).user_id)
          Task.destroyRecord(@@edit_id)
          @@edit_id = 0             # 編集処理が完了したのでedit_idを初期化
          @err_id = "正常"          # 正常に追加
          redirect_to :action =>"insert"
        else
          @err_id = "締切"          # 日程が異常
          render nothing: true, status: 400
        end
      else
        @err_id = "名前"        # 名前が0文字または50文字以上
      end
    end
  end
  def self.toRange(schedules)
    schedules.map {|s| s.start_time..s.end_time}
  end

  def self.calc_available_time task_record_or_id, current_time=nil
    # 併合
    def self.ranges_overlap?(a, b)
      a.include?(b.begin) || b.include?(a.begin)
    end
    def self.merge_ranges(a, b)
      [a.begin, b.begin].min..[a.end, b.end].max
    end
    def self.merge_overlapping_ranges(ranges)
      ranges.sort_by(&:begin).inject([]) do |ranges, range|
        if !ranges.empty? && ranges_overlap?(ranges.last, range)
          ranges[0...-1] + [merge_ranges(ranges.last, range)]
        else
          ranges + [range]
        end
      end
    end
    # def self.ranges_overlap?(a, b)
    #   Schedule.include?(a, b.start_time) || Schedule.include?(b, a.start_time)
    # end
    # def self.merge_ranges(a, b)
    #   [a.start_time, b.start_time].min..[a.end_time, b.end_time].max
    # end
    # def self.merge_overlapping_ranges(ranges)
    #   ranges.sort_by(&:start_time).inject([]) do |ranges, range|
    #     if !ranges.empty? && ranges_overlap?(ranges.last, range)
    #       ranges[0...-1] + [merge_ranges(ranges.last, range)]
    #     else
    #       ranges + [range]
    #     end
    #   end
    # end
    # 今の時間の取得
    
    now = !current_time.nil? ? current_time : Time.zone.now

    # deadlineの取得
    taskdata = task_record_or_id.instance_of?(Task) ? task_record_or_id : Task.find(task_record_or_id.to_i)
    deadline = taskdata.deadline
    available_time = deadline - now
    # p available_time.class
    # p available_time

    # 予定が入っている時間を引く
    schedules = merge_overlapping_ranges(toRange(Schedule.where(user_id: taskdata.user_id)))
    # p schedules
    schedules.each do |schedule|
      if schedule.begin < deadline && schedule.end > now then
        if schedule.begin >= now then
          if schedule.end < deadline then
            available_time -= (schedule.end - schedule.begin)
          elsif schedule.end >= deadline then
            available_time -= (deadline - schedule.begin)
          end
        elsif schedule.begin < now then
          if schedule.end <= deadline then
            available_time -= (schedule.end - now)
          elsif schedule.end > deadline then
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

  def self.busy_color id
    rate = Task.calc_rate_busy id
    if rate <= 0.75 then
      "bg-danger"
    elsif rate <= 0.85 then
      "bg-warning"
    else
      ""
    end
  end

  def self.alert id
    rate = Task.calc_rate_busy id
    # remaining_time = calc_available_time id #実質空き時間
    # deadline = Task.calc_deadtime id #締切
    if rate <= 0.4 then
      "alert"
    end
  end


  # 指定したユーザーID(メールアドレス情報)に対応するタスクデータをすべて取得する
  # @param user_email [String]  ユーザーを識別するためのメールアドレス（）
  # @return [Array<Task>]  対応するタスクデータの配列，user_emailがnilの場合は未ログイン状態で登録したタスクを取得する
  def self.get_visible_tasks(user_email = nil)
    if user_email
      Task.where(user_id: user_email)
    else
      Task.where(user_id: nil)
    end
  end

  def nearest_id
    tasks = get_visible_tasks(user_signed_in? ? current_user.email : nil).order("deadline ASC")
    tasks[0].id
  end

end
