# coding: utf-8
require 'date'
require 'time'
class ScheduleController < ApplicationController
  @err_id = "初期" #1:名前 2:開始日時 3:終了日時 4:終始逆 0:正常 -1:初期

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
      s_year = params['s_year']
      s_month = params['s_month']
      s_day = params['s_day']
      s_hour = params['s_hour']
      s_minute = params['s_minute']

      e_year = params['e_year']
      e_month = params['e_month']
      e_day = params['e_day']
      e_hour = params['e_hour']
      e_minute = params['e_minute']
      s_elements = [s_year, s_month, s_day, s_hour, s_minute]
      e_elements = [e_year, e_month, e_day, e_hour, e_minute]
      if (name.length <= 50 && name.length > 0) then 
        if (s_elements.all? {|t| !t.empty? && !t.nil?}) then
          if (e_elements.all? {|t| !t.empty? && !t.nil?}) then
            if self.is_valid_date(s_year.to_i, s_month.to_i, s_day.to_i, s_hour.to_i, s_minute.to_i) &&
	             self.is_valid_date(e_year.to_i, e_month.to_i, e_day.to_i, e_hour.to_i, e_minute.to_i) then
            	  start_time = Time.zone.local(s_year.to_i, s_month.to_i, s_day.to_i, s_hour.to_i, s_minute.to_i)
            	  end_time = Time.zone.local(e_year.to_i, e_month.to_i, e_day.to_i, e_hour.to_i, e_minute.to_i)
                if end_time > start_time then
              	  object = Schedule.new(
                        :name => name,
                        :start_time => start_time,
                        :end_time => end_time)
              	   object.save
                    @err_id = "正常"
                    #redirect_to :action =>"display"
                  else
                    @err_id = "終始逆"
                    render nothing: true, status: 400
                  end
            end
          else
          	@err_id = "終了日時"
          	render nothing: true, status: 400
          end
        else
          @err_id = "開始日時"
            render nothing: true, status: 400
        end
      else
        @err_id = "名前"
        render nothing: true, status: 400
      end
    end
  end

  def display
    @err_id = "初期"
    @schedules = Schedule.all
    # p @schedules
  end

  def delete
    id = params['id']
    object = Schedule.find(id)
    if !object.nil? then
      object.destroy
      @err_id = "初期"
    end
    #redirect_to :action =>"display"
    redirect_to :action =>"insert"
  end
end
