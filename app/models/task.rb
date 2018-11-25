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
  def self.calc_splited_time(id, now=Time.zone.now())
    now - Time.zone.now()
  end

  def self.calc_available_time task_record_or_id, current_time=nil
    taskdata = task_record_or_id.instance_of?(Task) ? task_record_or_id : Task.find(task_record_or_id.to_i)
    deadline = taskdata.deadline

    tasks = Task.all
    tasks.sort{ |a, b| a.deadline <=> b.deadline }
    n = 0
    tmp_task = []
    tasks.each do |task|
      # available_time の計算に係るタスクの総数
      if task.deadline > now && task.deadline < deadline then
        n += n
        tmp_task << task.id
      end
    end

    available_time = 0
    k = 1
    tasks.each do |task|
      # 一番現在時刻に近い締切のタスクの available_time を最初に計算して、それを2番目以降に締め切りの近いタスクの available_time の計算に利用する。
      # もし、他のタスクの期限が現在時刻よりあとだったら（本当は自分の期限より前のタスクの計算も個別に行う？）
      # 期限までのタスクの数だけデッドラインまでの空き時間を分割する
      if task.deadline > now && task.deadline < deadline then
        available_time += (TaskController.calc_available_time(tmp_task[k-1]) - available_time) / (n - k + 1)
        k += 1
      end
    end
  end
  available_time
end
