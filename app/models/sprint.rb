class Sprint < ApplicationRecord
  validates :start_date, :end_date, presence: true

  validate :no_weekend_day

  after_create :create_meetings

  def self.current
    find_by('start_date <= :today AND end_date >= :today', today: Time.zone.today)
  end

  private

  def no_weekend_day
    return unless start_date.on_weekend? || end_date.on_weekend?

    errors[:base] << 'The dates of the sprint could not start/end on weekend'
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
