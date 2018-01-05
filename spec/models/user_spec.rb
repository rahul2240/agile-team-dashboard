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
        # Create additional users that should not be returned by the method
        range(0, 10).times { FactoryBot.create(:user, birthday: range(16, 70).years.ago + range(7, 364).days) }
        (1..range(0, 10)).map { FactoryBot.create(:user, birthday: range(16, 70).years.ago + range(0, 6).days) }
      }.check(1) { |user_with_birthdays_this_week|
        expect(User.with_birthday).to eq(user_with_birthdays_this_week)
      }
    end

    context 'with a user with birthday on 29th February' do
      let!(:user_born_on_29_02) { create :user, birthday: Date.new(1976, 2, 29) }

      before do
        allow(Date).to receive(:current).and_return(Date.new(2017, 2, 28))
      end

      it { expect(User.with_birthday).to eq([user_born_on_29_02]) }
    end

    context 'with a user with birthday on 1st January' do
      let!(:user_born_on_01_01) { create :user, birthday: Date.new(1991, 1, 1) }

      before do
        allow(Date).to receive(:current).and_return(Date.new(2017, 12, 29))
      end

      it { expect(User.with_birthday).to eq([user_born_on_01_01]) }
    end
  end
end
