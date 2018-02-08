# frozen_string_literal: true

# Calendar Controller
class CalendarsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: calendar_data }
    end
  end

  private

  def calendar_data
    start_date = params[:start].presence || Time.zone.today.beginning_of_month
    end_date = params[:end].presence || Date.end.beginning_of_month

    events = Event.in_month(start_date).map do |event|
      CalendarEvent.new(title: event.title,
                        start: event.start_date,
                        end: event.end_date,
                        description: event.description,
                        color: event.color,
                        allDay: event.all_day?)
    end
    public_holidays =
      Holidays.between(start_date, end_date, %i[es gb cz]).map do |holiday|
        CalendarEvent.new(
          title: "#{holiday[:regions].first.try(:to_s)} - #{holiday[:name]}",
          start: holiday[:date],
          color: '#DECAEE',
          textColor: 'black'
        )
      end

    events + public_holidays
  end
end
