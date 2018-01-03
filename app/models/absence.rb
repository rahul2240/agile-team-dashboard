class Absence < Event
  validates :start_date, :end_date, :event_type, presence: true

  scope :week, (-> { where('start_date <= ? AND end_date >= ?', Date.current + 6.days, Date.current) })

  # Contants
  #
  TYPES = %i[workshop vacation sick other].freeze
end

# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  location    :string
#  start_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_type  :string
#  end_date    :date
#  user_id     :integer
#  type        :string
#  description :text
#
