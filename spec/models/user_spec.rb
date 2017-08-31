require 'rails_helper'

RSpec.describe User, type: :model do
  %i(name).each do |attr|
    it { should validate_presence_of(attr) }
  end
end
