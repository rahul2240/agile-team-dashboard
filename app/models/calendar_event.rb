# frozen_string_literal: true

class CalendarEvent
  include ActiveModel::Model
  attr_accessor :title, :description, :start, :end, :color, :textColor, :allDay
end
