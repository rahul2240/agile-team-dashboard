require 'rails_helper'

RSpec.describe MeetingsController, type: :controller do
  let(:user) { create :user }
  let(:standup) { create :standup }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'showing all meetings' do
      before do
        get :index
      end

      it { expect(assigns(:active_meetings).size).to eq(Meeting.active.count) }
      it { expect(assigns(:finished_meetings).size).to eq(Meeting.finished.count) }
    end
  end

  describe 'GET #create' do
    let(:sprint) { create(:sprint) }
    before do
      post :create, params: { meeting: { name: 'planning', start_date: Time.zone.today, end_date: Time.zone.today,
                                         location: 'mumble', event_type: 'planning', sprint_id: sprint } }
    end

    it { expect(response).to redirect_to(meetings_path) }
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: standup.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    before do
      get :edit, params: { id: standup.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #update' do
    before do
      patch :update, params: { id: standup.id, meeting: { name: 'updated' } }
    end

    it { expect(response).to redirect_to(meetings_path) }
  end

  describe 'GET #destroy' do
    before do
      delete :destroy, params: { id: standup.id }
    end

    it { expect(response).to redirect_to(meetings_path) }
  end
end
