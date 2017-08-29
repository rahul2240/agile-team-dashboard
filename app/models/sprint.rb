class Sprint < ApplicationRecord
  validates :start_date, :end_date, presence: true

  validate :no_weekend_day

  scope :current, (-> { find_by('start_date <= :today AND end_date >= :today', today: Time.zone.today) })

  after_create :create_meetings

  private

  def no_weekend_day
    return unless weekend?(start_date.try(:cwday)) || weekend?(end_date.try(:cwday))

    errors[:base] << 'The dates of the sprint could not start/end on weekend'
  end

  def weekend?(date)
    date.in?([0, 6, 7])
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
