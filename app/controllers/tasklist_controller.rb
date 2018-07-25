class TasklistController < ApplicationController

  @err_flag = false

  def insert
    if request.post? then
      name = params['name']
      year = params['year']
      month = params['month']
      day = params['day']
      hour = params['hour']
      minute = params['minute']

      elements = [name, year, month, day, hour, minute]
      if elements.all? {|t| !t.empty? && !t.nil?}
        Tasklist.addtasks(name, year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)
        @err_flag = false
        redirect_to :action =>"display"
      else
        @err_flag = true
        render nothing: true, status: 400
      end
    end
  end

  def create
    # Tasklist.task_count += 1
    # task = [name, date]
  end

  def delete
    id = params['id']
    Tasklist.delete_task(id.to_i)
    @err_flag = false
    redirect_to :action =>"display"
  end

  def display
    @err_flag = false
    @tasks = Tasklist.get_tasks
    @task_count = Tasklist.get_task_count
  end
end