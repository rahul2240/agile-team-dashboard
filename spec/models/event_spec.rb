require 'rails_helper'

RSpec.describe Meeting, type: :model do
  %i(location start_date end_date event_type).each do |attr|
    it { should validate_presence_of(attr) }
  end

  context 'validate' do
    context 'ends_before_start' do
      let(:event) { build(:event, event_type: :vacation, start_date: '2017-10-04', end_date: '2017-10-02') }

      before do
        event.valid?
      end

      it { expect(event.errors.full_messages).to eq(['End date can not end before start']) }
    end
  end

  let(:vacation) { create(:event, event_type: :vacation) }
  let(:sick) { create(:event, event_type: :sick) }
  let(:standup) { create(:event, event_type: :standup) }
  let(:retrospective) { create(:event, event_type: :retrospective) }
  let(:workshop) { create(:event, event_type: :workshop) }
  let(:meeting) { create(:event, event_type: :meeting) }
  let(:other) { create(:event, event_type: :other) }

  context '#title' do
    let(:user)  { create(:user) }
    let(:event) { create(:event, user: user) }

    it { expect(event.title).to eq("#{user.name} - #{event.event_type}") }
  end

  context '#all_day?' do
    it { expect(vacation.all_day?).to be_truthy }
    it { expect(sick.all_day?).to be_truthy }
    it { expect(standup.all_day?).to be_falsey }
    it { expect(retrospective.all_day?).to be_falsey }
    it { expect(workshop.all_day?).to be_falsey }
    it { expect(meeting.all_day?).to be_falsey }
    it { expect(other.all_day?).to be_falsey }
  end

  context '#color' do
    it { expect(vacation.color).to eq('#88b200') }
    it { expect(sick.color).to eq('red') }
    it { expect(standup.color).to eq('#0088b2') }
    it { expect(retrospective.color).to eq('#491b47') }
    it { expect(workshop.color).to eq('#920076') }
    it { expect(meeting.color).to eq('#bf4469') }
    it { expect(other.color).to eq('#c25975') }
  end
end
