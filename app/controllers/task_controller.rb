class TaskController < ApplicationController
  @err_flag = false

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
      elements = [name, year, month, day, hour, minute]
      if (elements.all? {|t| !t.empty? && !t.nil?}) && is_valid_date(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i) then
       Task.new(:name => name, :deadline => Time.zone.local(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)).save
       @err_flag = false
       redirect_to :action =>"display"
     else
      @err_flag = true
      render nothing: true, status: 400
    end
  end

end

def display
end

def delete
end
end
