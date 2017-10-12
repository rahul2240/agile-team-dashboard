require 'rails_helper'

RSpec.describe Absence, type: :model do
  %i(start_date end_date event_type).each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe '#TYPES' do
    %i(workshop vacation sick other).each do |cons|
      it { expect(Absence::TYPES).to include(cons) }
    end

    it { expect(Absence::TYPES.count).to eq(4) }
  end

  describe 'scope today' do
    let!(:vacation1) do
      create(:absence, event_type: :vacation, start_date: Time.zone.today - 1.hour, end_date: Time.zone.today)
    end
    let!(:vacation2) do
      create(:absence, event_type: :vacation, start_date: Time.zone.today - 3, end_date: Time.zone.today)
    end
    let!(:vacation3) do
      create(:absence, event_type: :vacation, start_date: Time.zone.today, end_date: Time.zone.today + 5)
    end
    let!(:vacation4) do
      create(:absence, event_type: :vacation, start_date: Time.zone.today - 6, end_date: Time.zone.today + 5)
    end
    let!(:sick1) do
      create(:absence, event_type: :sick, start_date: Time.zone.today - 6, end_date: Time.zone.today - 1)
    end
    let!(:sick2) do
      create(:absence, event_type: :sick, start_date: Time.zone.today + 3, end_date: Time.zone.today + 10)
    end

    it { expect(Absence.today).to match_array([vacation1, vacation2, vacation3, vacation4]) }
  end
end
