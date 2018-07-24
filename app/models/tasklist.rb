class Tasklist
  # cattr_accessor :tasks
  # cattr_accessor :task_count
  @tasks = []
  @task_count = 0

  def self.addtasks name, date
    puts name
    puts date
    @tasks[@task_count] = [@task_count, name, date]
    @task_count += 1
    puts @tasks
  end

  def self.get_tasks
    @tasks
  end

  def self.delete_task id
    if @tasks.delete_at(id) != nil then
      @task_count-=1
    end
  end

  def self.get_task_count
    @task_count
  end

end
