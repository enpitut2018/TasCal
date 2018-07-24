class TasklistController < ApplicationController  
  def insert
    if request.post? then
      name = params['name']
      date = params['date']

      Tasklist.addtasks(name, date)
    end
  end

  def create
    # Tasklist.task_count += 1
    # task = [name, date]
  end

  def delete
    id = params['id']
    Tasklist.delete_task(id.to_i)
    redirect_to :action =>"display"
  end

  def display
    @tasks = Tasklist.get_tasks
    @task_count = Tasklist.get_task_count
  end
end
