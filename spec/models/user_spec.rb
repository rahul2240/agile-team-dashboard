require 'rails_helper'

RSpec.describe User, type: :model do
  %i[name].each do |attr|
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

    context 'with a user with birthday on 29th February' do
      let!(:user_born_on_29_02) { create :user, birthday: Date.new(1976, 2, 29) }

      before do
        allow(Date).to receive(:current).and_return(Date.new(2017, 2, 28))
      end

      it { expect(User.birthdays_of_this_week).to eq([user_born_on_29_02]) }
    end

    context 'with a user with birthday on 1st January' do
      let!(:user_born_on_01_01) { create :user, birthday: Date.new(1991, 1, 1) }

      before do
        allow(Date).to receive(:current).and_return(Date.new(2017, 12, 29))
      end

      it { expect(User.birthdays_of_this_week).to eq([user_born_on_01_01]) }
    end
  end
end
