require 'rails_helper'

RSpec.describe CreateMeetings, type: :service do
  let(:start_date) { Date.parse('2017-08-07') }
  let(:end_date) { Date.parse('2017-08-18') }

  context '#self.run' do
    context 'normal sprint of 2 weeks' do
      let!(:sprint) { create(:sprint) }

      it { expect(Meeting.where(event_type: :planning).count).to eq(2) }
      it { expect(Meeting.where(event_type: :standup).count).to eq(8) }
      it { expect(Meeting.where(event_type: :grooming).count).to eq(1) }
      it { expect(Meeting.where(event_type: :review).count).to eq(1) }
      it { expect(Meeting.where(event_type: :retrospective).count).to eq(1) }
    end

    context 'sprint start on Wednesday, 7 days' do
      let!(:sprint) { create(:sprint, start_date: '2017-08-09', end_date: '2017-08-18') }

      it { expect(Meeting.where(event_type: :planning).count).to eq(2) }
      it { expect(Meeting.where(event_type: :standup).count).to eq(6) }
      it { expect(Meeting.where(event_type: :grooming).count).to eq(1) }
      it { expect(Meeting.where(event_type: :review).count).to eq(1) }
      it { expect(Meeting.where(event_type: :retrospective).count).to eq(1) }
    end

    context 'strange sprint of 1 week' do
      let!(:sprint) { create(:sprint, start_date: '2017-08-07', end_date: '2017-08-11') }

      it { expect(Meeting.where(event_type: :planning).count).to eq(2) }
      it { expect(Meeting.where(event_type: :standup).count).to eq(3) }
      it { expect(Meeting.where(event_type: :grooming).count).to eq(0) }
      it { expect(Meeting.where(event_type: :review).count).to eq(1) }
      it { expect(Meeting.where(event_type: :retrospective).count).to eq(1) }
    end
  end

  context 'different type of meetings' do
    let(:sprint_2) { create(:sprint) }

    before do
      sprint_2
      Meeting.destroy_all
    end

    context '#self.create_standups' do
      before do
        CreateMeetings.create_standups(start_date, end_date, sprint_2)
      end

      it { expect(Meeting.where(event_type: :standup).count).to eq(8) }
    end

    context '#self.create_plannings' do
      before do
        CreateMeetings.create_plannings(start_date, sprint_2)
      end

      it { expect(Meeting.where(event_type: :planning).count).to eq(2) }
    end

    context '#self.create_grooming' do
      before do
        CreateMeetings.create_grooming(start_date, end_date, sprint_2)
      end

      subject { Meeting.where(event_type: :grooming) }

      it { expect(subject.count).to eq(1) }
      it { expect(subject.first.start_date.monday?).to be_truthy }
    end

    context '#self.create_review' do
      before do
        CreateMeetings.create_review(end_date, sprint_2)
      end

      it { expect(Meeting.where(event_type: :review).count).to eq(1) }
    end

    context '#self.create_retrospective' do
      before do
        CreateMeetings.create_retrospective(end_date, sprint_2)
      end

      it { expect(Meeting.where(event_type: :retrospective).count).to eq(1) }
    end
  end
end
