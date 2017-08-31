require 'rails_helper'

RSpec.describe User, type: :model do
  %i(name).each do |attr|
    it { should validate_presence_of(attr) }
  end

  let(:user) { create :user }

  context '#fullname' do
    it { expect(user.fullname).to eq("#{user.name} #{user.surname}") }
  end
end
