# coding: utf-8
class Task < ApplicationRecord
  def self.calc_deadtime id
    #締め切りまでの時間(min)
    task = Task.all.find(id)
    time = task.deadline - Time.zone.now
    time = time / 60

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
      f_time = calc_splited_time id
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
  def self.calc_splited_time(task_record_or_id, current_time=nil)
    # 今の時間の取得
    now = !current_time.nil? ? current_time : Time.zone.now
    
    taskdata = task_record_or_id.instance_of?(Task) ? task_record_or_id : Task.find(task_record_or_id.to_i)
    deadline = taskdata.deadline

    tasks = Task.order('deadline ASC')
    n = 0
    tmp_task = []
    tasks.each do |task|
      # available_time の計算に係るタスクの総数
      if task.deadline > now then
        n += 1
        tmp_task << task.id
        logger.debug task.deadline
      end
    end

    logger.debug n

    available_time = 0
    prev_deadline = 0
    prev_available_time = 0
    split_time_sum = 0
    k = 0
    tasks.each do |task|
      # 一番現在時刻に近い締切のタスクの available_time を最初に計算して、それを2番目以降に締め切りの近いタスクの available_time の計算に利用する。
      # 期限までのタスクの数だけデッドラインまでの空き時間を分割する
      if task.deadline > now && task.deadline <= deadline then
        logger.debug TaskController.calc_available_time(task.id)
        logger.debug k
        current_task_available_time = TaskController.calc_available_time(task.id, now)

        if prev_deadline == task.deadline then
          split_time_sum == (current_task_available_time - prev_available_time) / (n - k)
        else
          split_time_sum += (current_task_available_time - prev_available_time) / (n - k)
        # available_time += TaskController.calc_available_time(tmp_task[k-1])
          prev_available_time = current_task_available_time
        end

        logger.debug available_time
        k += 1
        prev_deadline = task.deadline
      end
    end
    split_time_sum
    # available_time / n
  end
end
