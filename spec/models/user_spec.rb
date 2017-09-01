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
    let!(:user1) { create(:user, birthday: 20.years.ago) }
    let!(:user2) { create(:user, birthday: 35.years.ago + 13.days) }
    let!(:user3) { create(:user, birthday: 18.years.ago + 3.days) }
    let!(:user4) { create(:user, birthday: 57.years.ago + 6.days) }
    let!(:user5) { create(:user, birthday: 31.years.ago - 1.day) }

    it { expect(User.birthdays_of_this_week).to eq([user1, user3, user4]) }
  end
end
