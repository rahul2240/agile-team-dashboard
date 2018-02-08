# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :user, optional: true

  scope :active, (lambda do
    where('DATE(start_date) <= :today AND DATE(end_date) >= :today', today: Time.zone.today)
      .order(start_date: :asc)
  end)
  scope :finished, (-> { where('DATE(end_date) < ?', Time.zone.today).order(start_date: :asc) })
  scope :in_month, (lambda do |start_date|
    where('start_date >= ?', start_date)
  end)

  validate :ends_before_start

  # Contants
  #
  COLORS = {
    vacation: '#88b200',
    sick: 'red',
    standup: '#0088b2',
    planning: '#ffc125',
    retrospective: '#491b47',
    workshop: '#920076',
    meeting: '#bf4469',
    other: '#c25975'
  }.freeze

  # Instance methods
  #
  def title
    [user.try(:name), event_type].reject(&:blank?).join(' - ')
  end

  def all_day?
    %w[vacation sick].include?(event_type)
  end

  def color
    COLORS[event_type.try(:to_sym)]
  end

  private

  def ends_before_start
    return unless start_date && end_date
    errors[:end_date] << 'can not end before start' if start_date >= end_date
  end
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
