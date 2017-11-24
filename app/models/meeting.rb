class Meeting < Event
  belongs_to :sprint

  validates :location, :start_date, :end_date, :event_type, presence: true

  scope :today, (-> { where('DATE(start_date) = ?', Time.zone.today).order(start_date: :asc) })
  scope :standups, -> { where(event_type: 'standup') }
  scope :started_after_until, ->(date1, date2) { where('start_date > ? AND start_date <= ?', date1, date2) }
  scope :reviews, -> { where(event_type: 'review') }
  scope :ended_after_until, ->(date1, date2) { where('end_date > ? AND end_date <= ?', date1, date2) }

  # Contants
  #
  TYPES = %i(standup planning review retrospective meeting workshop grooming other).freeze
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
