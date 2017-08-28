class Sprint < ApplicationRecord
  validates :start_date, :end_date, presence: true

  scope :current, (-> { find_by('start_date <= :today AND end_date >= :today', today: Time.zone.today) })

  after_create :create_meetings

  private

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
