require 'rails_helper'

RSpec.describe Sprint, type: :model do
  %i(number start_date end_date).each do |attr|
    it { should validate_presence_of(attr) }
  end
end
