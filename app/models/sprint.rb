class Sprint < ApplicationRecord
  validates :number, :start_date, :end_date, presence: true
  validate :starts_on_weekday, :ends_on_weekday

  after_create :create_meetings

  def self.current
    find_by('start_date <= :today AND end_date >= :today', today: Time.zone.today)
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
