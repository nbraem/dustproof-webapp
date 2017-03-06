require 'rails_helper'

RSpec.describe MeasurementsController, type: :controller do
  let(:user) { FactoryGirl.create(:user, confirmed_at: Time.now) }
  let(:device) { FactoryGirl.create(:device, user: user) }
  let!(:measurement) { FactoryGirl.create(:measurement, device: device) }

  context "when not logged in" do
    describe "GET #index" do
      it "redirects to the sign in page" do
        get :index, params: { device_id: device.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  context "when logged in as the device's user" do
    before(:each) do
      login_user(device.user)
    end

    describe "GET #index" do
      it "assigns all measurements as @measurements" do
        get :index, params: { device_id: device.to_param }, format: :html
        expect(assigns(:measurements)).to include(measurement)
        expect(response).to render_template(:index) 
      end

      context "when requesting csv format" do
        it "renders csv" do
          get :index, params: { device_id: device.to_param }, format: :csv
          expect(response.header['Content-Type']).to include('text/csv')
        end
      end
    end
  end
end
