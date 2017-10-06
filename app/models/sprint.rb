class Sprint < ApplicationRecord
  has_many :meetings, dependent: :destroy
  validates :number, :start_date, :end_date, presence: true
  validate :starts_on_weekday, :ends_on_weekday

  after_create :create_meetings

  def self.current
    find_by('start_date <= :today AND end_date >= :today', today: Time.zone.today)
  end

  def unstarted_sprint?
    start_date.today? && !File.exist?('trollolo/burndown-data-02.yaml')
  end

  def days
    1 + (end_date - start_date).to_i - (2 * number_weekends)
  end

  def weekend_lines
    first_line = 6.5 - start_date.cwday
    (0..(number_weekends - 1)).map { |i| first_line + (i * 5) }.join(' ')
  end

  private

  def starts_on_weekday
    errors[:start_date] << 'can not be on weekend' if start_date.try(:on_weekend?)
  end

  def ends_on_weekday
    errors[:end_date] << 'can not be on weekend' if end_date.try(:on_weekend?)
  end

  def create_meetings
    CreateMeetings.run(self)
  end

  def number_weekends
    end_date.cweek - start_date.cweek
  end
end

# == Schema Information
#
# Table name: sprints
#
#  id         :integer          not null, primary key
#  start_date :date
#  end_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
