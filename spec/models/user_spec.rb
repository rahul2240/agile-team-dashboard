require 'rails_helper'

RSpec.describe User, type: :model do
  %i(name).each do |attr|
    it { should validate_presence_of(attr) }
  end

  let(:user) { create :user }

  describe '#fullname' do
    it { expect(user.fullname).to eq("#{user.name} #{user.surname}") }
  end

  describe '#self.birthdays_of_this_week' do
    it 'with some users with and without birthday' do
      property_of {
        birthdays_this_week = []
        birthdays_other_week = []
        range(0, 10).times { birthdays_this_week << range(16, 70).years.ago + range(0, 6).days }
        range(0, 10).times { birthdays_other_week << range(16, 70).years.ago + range(7, 364).days }
        [birthdays_this_week, birthdays_other_week]
      }.check(1) { |birthdays_this_week, birthdays_other_week|
        users_with_birthday = []
        birthdays_this_week.each do |birthday|
          users_with_birthday << create(:user, birthday: birthday)
        end
        users_without_birthday = []
        birthdays_other_week.each do |birthday|
          users_without_birthday << create(:user, birthday: birthday)
        end
        expect(User.birthdays_of_this_week).to eq(users_with_birthday)
      }
    end
  end
end
