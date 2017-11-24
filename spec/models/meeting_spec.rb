require 'rails_helper'

RSpec.describe Meeting, type: :model do
  %i(start_date end_date event_type location).each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe '#TYPES' do
    %i(standup planning retrospective meeting workshop other).each do |cons|
      it { expect(Meeting::TYPES).to include(cons) }
    end

    it { expect(Meeting::TYPES.count).to eq(8) }
  end

  let(:user) { create :user }
  let(:standup) { create :standup }
  let(:planning) { create :planning }
  let(:retrospective) { create :retrospective }
  let(:workshop) { create :workshop }

  describe '#color' do
    it 'standup' do
      expect(standup.color).to eq('#0088b2')
    end

    it 'planning' do
      expect(planning.color).to eq('#ffc125')
    end

    it 'retrospective' do
      expect(retrospective.color).to eq('#491b47')
    end

    it 'workshop' do
      expect(workshop.color).to eq('#920076')
    end
  end
end
