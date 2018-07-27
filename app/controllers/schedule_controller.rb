require 'date'
require 'time'
class ScheduleController < ApplicationController

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

			elements = [name, s_year, s_month, s_day, s_hour, s_minute,  e_year, e_month, e_day, e_hour, e_minute]
			if (elements.all? {|t| !t.empty? && !t.nil?}) &&
				self.is_valid_date(s_year.to_i, s_month.to_i, s_day.to_i, s_hour.to_i, s_minute.to_i) &&
				self.is_valid_date(e_year.to_i, e_month.to_i, e_day.to_i, e_hour.to_i, e_minute.to_i) then
				start_time = Time.zone.local(s_year.to_i, s_month.to_i, s_day.to_i, s_hour.to_i, s_minute.to_i)
				end_time = Time.zone.local(e_year.to_i, e_month.to_i, e_day.to_i, e_hour.to_i, e_minute.to_i)
				object = Schedule.new(
                                  :name => name,
                                  :start_time => start_time,
                                  :end_time => end_time)
				object.save

				@err_flag = false
			        #redirect_to :action =>"display"
			else
				@err_flag = true
				render nothing: true, status: 400
			end
		end
	end

	def display
		@err_flag = false
    @schedules = Schedule.all
    p @schedules
	end

	def delete
		id = params['id']
    object = Schedule.find(id)
    if !object.nil? then
	    object.destroy
	    @err_flag = false
	  end
    #redirect_to :action =>"display"
    redirect_to :action =>"insert"
	end
end
