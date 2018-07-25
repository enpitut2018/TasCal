require 'date'
require 'time'

class Tasklist
  # cattr_accessor :tasks
  # cattr_accessor :task_count
  @tasks = []
  @task_count = 0

  def self.addtasks name, year, month, day, hour, minute
    if Date.valid_date?(year,month,day)

      begin
        parsed_time = Time.parse(hour.to_s + ":" + minute.to_s)
      rescue ArgumentError => e
        return false
      end

      @tasks[@task_count] = [@task_count, name, year, month, day, hour, minute]
      @task_count += 1

      return true
    end
  end

  def self.get_tasks
    return_tasks_info = []
    for task in @tasks do
      return_tasks_info.push [task[0], task[1], task[2], task[3], task[4], task[5], task[6], TasklistController.calc_available_time(task[0])]
    end

    return_tasks_info
  end

  def self.delete_task id
    if @tasks.delete_at(id) != nil then
      @task_count-=1
    end
  end

  def self.get_task id
    @tasks[id]
  end

  def self.get_task_count
    @task_count
  end

  def self.cleanup
    @tasks = []
    @task_count = 0
  end

end
