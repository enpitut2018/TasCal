class TasklistController < ApplicationController  
  def insert
    if request.post? then
      name = params['taskname']
      date = params['date']

      Tasklist.addtasks(name, date)
    end
  end

  def create
    # Tasklist.task_count += 1
    # task = [name, date]
  end

  def delete
  end

  def display
    @tasks = Tasklist.get_tasks
    @task_count = Tasklist.get_task_count
  end
end
