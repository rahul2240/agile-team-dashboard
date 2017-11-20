require 'rails_helper'

RSpec.describe Sprint, type: :model do
  %i(number start_date end_date).each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe 'validate' do
    context 'start_on_weekend' do
      let(:sprint) { build(:sprint, start_date: '2017-10-07', end_date: '2017-10-12') }

      before do
        sprint.valid?
      end

      it { expect(sprint.errors.full_messages).to eq(['Start date can not be on weekend']) }
    end

    context 'end_on_weekend' do
      let(:sprint) { build(:sprint, start_date: '2017-10-05', end_date: '2017-10-08') }

      before do
        sprint.valid?
      end

      it { expect(sprint.errors.full_messages).to eq(['End date can not be on weekend']) }
    end

    context 'longer_than_three_days' do
      let(:sprint) { build(:sprint, start_date: '2017-10-02', end_date: '2017-10-04') }

      before do
        sprint.valid?
      end

      it { expect(sprint.errors.full_messages).to eq(['End date sprints with less than 3 days are not allowed']) }
    end

    context 'sprint_collision' do
      let(:sprint) { create(:sprint, start_date: '2017-10-02', end_date: '2017-10-13') }
      let(:invalid_sprint) { build(:sprint, start_date: '2017-10-06', end_date: '2017-10-12') }

      before do
        sprint
        invalid_sprint.valid?
      end

      subject { invalid_sprint.errors.full_messages }

      it { expect(subject.first).to eq('Start date there is already a sprint in those dates') }
    end
  end
end
