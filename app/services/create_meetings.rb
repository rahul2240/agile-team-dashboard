# frozen_string_literal: true

class CreateMeetings
  def self.run(sprint)
    create_plannings(sprint.start_date, sprint)
    create_standups(sprint.start_date, sprint.end_date, sprint)
    create_grooming(sprint.start_date, sprint.end_date - 1, sprint)
    create_review(sprint.end_date, sprint)
    create_retrospective(sprint.end_date, sprint)
  end

  def self.create_standups(start_date, end_date, sprint)
    (start_date + 1...end_date).each do |date|
      if date.on_weekday?
        sprint.meetings.create!(name: 'Standup', event_type: :standup, start_date: datetime(date, '11:00'),
                                end_date: datetime(date, '11:30'), location: 'mumble')
      end
    end
  end

  def self.create_plannings(date, sprint)
    sprint.meetings.create!(name: 'Planning part 1', event_type: :planning, start_date: datetime(date, '11:00'),
                            end_date: datetime(date, '12:00'), location: 'gotomeeting')
    sprint.meetings.create(name: 'Planning part 2', event_type: :planning, start_date: datetime(date, '13:30'),
                           end_date: datetime(date, '15:00'), location: 'gotomeeting')
  end

  def self.create_grooming(start_date, end_date, sprint)
    return unless start_date.next_week <= end_date

    date = start_date.next_week
    sprint.meetings.create(name: 'Grooming', event_type: :grooming, start_date: datetime(date, '14:00'),
                           end_date: datetime(date, '16:00'), location: 'gotomeeting')
  end

  def self.create_review(date, sprint)
    sprint.meetings.create(name: 'Review', event_type: :review, start_date: datetime(date, '11:00'),
                           end_date: datetime(date, '12:00'), location: 'gotomeeting')
  end

  def self.create_retrospective(date, sprint)
    sprint.meetings.create(name: 'Retrospective', event_type: :retrospective, start_date: datetime(date, '14:00'),
                           end_date: datetime(date, '16:00'), location: 'mumble')
  end

  def self.datetime(date, time)
    [date, time].join(' ').to_datetime
  end
  private_class_method :datetime
end
