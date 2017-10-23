require 'rails_helper'

RSpec.describe ::Team::MembersController, type: :controller do
  let(:user) { create :user, name: 'fake_user' }
  let(:update_action) { put :update, params: { id: user, user: { name: 'testname' } } }

  before do
    sign_in user
  end

  describe "PUT 'update'" do
    it "changes user's name" do
      expect { update_action }.to change { user.reload.name }.from('fake_user').to('testname')
    end
  end
end
