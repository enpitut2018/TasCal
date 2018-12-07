# coding: utf-8
require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  @now # date
  @avail # : Task.id -> date
  @split # : Task.id -> date
  #除算の誤差がひどい場合は各自で丸めて下さい
  @distance # : date -> date -> float  
  @do_equal # : date -> date -> (date -> date -> float) ->  assert  
  @almost0 # : float
  def setup
    Task.destroy_all
    Schedule.destroy_all
    @now =  Time.zone.local(2018, 7, 25, 12, 0)
    @avail = lambda { |id|
      TaskController.calc_available_time(id, @now)
    } 
    @split = lambda { |id|
      Task.calc_splited_time(id, @now)
    }
    #=======equalty test proc===========
    @distance = lambda { |t1, t2| t1 - t2 }
    @almost0 = 0
    @do_equal = proc {|t1, t2, sub=@distance|
      assert_in_delta(@almost0, sub.(t1, t2))
    }
    #=======proc end====================
    insert_task name:"t_tomorrow"
    insert_schedule name:"s_day_after"
  end
  test "available time = splited time" do
    t = Task.all.find_by(name: "t_tomorrow")
    s = Schedule.all.find_by(name: "s_day_after")
    check = proc {@do_equal.call(@avail.(t.id), @split.(t.id))}
    check.call
    #from 11/26 11:00 to 11/26 12:00
    insert_schedule name:"s_today", s_hour:"11", e_day:"26", e_hour:"12"
    check.call()
  end

  test "task1 :=: task2" do
    insert_task name:"t_tomorrow'"
    task1 = Task.all.find_by(name: "t_tomorrow")
    task2 = Task.all.find_by(name: "t_tomorrow'")

    check = Proc.new do |task|
      assert_equal(60*24/2, @split.(task.id))
    end
    check.call(task1)
    check.call(task2)    
  end

  test "task1 :-: task2 = 12h" do
    check = proc{|task, hour|
      @do_equal.call(hour*60, @split.(task.id))
    }
    insert_task name:"t_tomorrow'", hour:"0"
    task1 = Task.all.find_by(name: "t_tomorrow")
    task2 = Task.all.find_by(name: "t_tomorrow'")
    check.call(task1, 18)
    check.call(task2, 6)
  end
  
  def three_task(h1, h2, h3)
    insert_task name:"t_tomorrow'", hour:"0"
    insert_task name:"t_today", day:"25", hour:"18"
    task1 = Task.all.find_by(name: "t_tomorrow")
    task2 = Task.all.find_by(name: "t_tomorrow'")
    task3 = Task.all.find_by(name: "t_today")
    check = proc{|task, hour|
      @do_equal.call(hour*60, @split.(task.id))
    }
    yield #continuation
    check.call(task1, h1)
    check.call(task2, h2)
    check.call(task3, h3)        
  end  # : float -> float -> float -> assert -> assert  

  test "task1 :-: task2 = 12h & task2 :-: task3 = 6h" do
    three_task(17,5,2) {}
  end  

  test "add schedule1(from 25 17:00 to 19:00 overlap task3&task2)" do
    t3 = 5.fdiv(3) # : float
    t2 = t3 + 5.fdiv(2) # : float
    t1 = t2 + 12.fdiv(1) # : float
    three_task(t1, t2, t3) {
      insert_schedule name:"s_today", s_day:"25", s_hour:"17", e_day:"25", e_hour:"19"
    }
  end 

  test "add schedule2(from 25 19:00 to 26 6:00 overlap task2&task1" do
    t3 = 6.fdiv(3) # : float
    t2 = t3 + 1.fdiv(2) # : float
    t1 = t2 + 6.fdiv(1) # : float
    three_task(t1, t2, t3) {
      insert_schedule name:"sleep", s_day:"25", s_hour:"19", e_day:"26", e_hour:"6"
    }
  end

  test "task-isolation" do
    insert_task name:"A's task", user_id:"a@site.com"
    tA = Task.all.find_by(name: "A's task")
    check = proc {|t| @do_equal.call(@avail.(t.id), @split.(t.id))}
    check.call(tA)
    insert_task name:"B's task", user_id:"b@site.com"
    tB = Task.all.find_by(name: "B's task")
    ckeck.call(tB)
  end

  def insert_task (name:, user_id:"aaa@example.com", year:"2018", month:"7", day:"26", hour:"12", minute:"0")
    Task.create(:user_id => user_id, :name => name,
                :deadline =>
                Time.zone.local(year, month, day,hour, minute))
  end
  def insert_schedule(name:, user_id:"aaa@example.com", s_year:"2018", s_month:"7", s_day:"26", s_hour:"12", s_minute:"0", e_year:"2018", e_month:"7", e_day:"27", e_hour:"12", e_minute:"0")
    start_time = Time.zone.local(s_year, s_month, s_day, s_hour, s_minute)
    end_time = Time.zone.local(e_year, e_month, e_day, e_hour, e_minute)
    Schedule.create(:user_id => user_id, :name => name,
                    :start_time => start_time, :end_time => end_time)
  end


end
