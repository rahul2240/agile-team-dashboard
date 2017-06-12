class Sprint < ApplicationRecord
  validates :start_date, :end_date, presence: true

  scope :current, (-> { find_by('start_date <= :today AND end_date >= :today', today: Time.zone.today) })
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
