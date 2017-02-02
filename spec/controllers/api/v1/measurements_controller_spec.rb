require "rails_helper"

describe Api::V1::MeasurementsController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:measurement) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_measurement) }
  let(:user) { FactoryGirl.create(:user, confirmed_at: Time.now) }
  let(:device) { FactoryGirl.create(:device, user: user) }
  let!(:measurement) { FactoryGirl.create(:measurement, device_id: device.id) }

  context "with an invalid API key" do
    describe "GET #index" do
      it "renders an error message" do
        get :index
        body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expect(body["error"]).to eql("Bad credentials")
      end
    end

    describe "POST #create" do
      it "renders an error message" do
        post :create, measurement: valid_attributes
        body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expect(body["error"]).to eql("Bad credentials")
      end
    end
  end

  context "with a valid API key" do
    describe "with valid params" do
      describe "GET #index" do
        it "lists measurements" do
          get :index, api_key: device.api_key
          expect(response.status).to eql(200)
          body = HashWithIndifferentAccess.new(JSON.parse(response.body))
          expect(body["measurements"][0]["id"]).to eql(measurement.id)
        end
      end

      describe "POST #create" do
        it "creates a new Measurement" do
          expect do
            post :create, measurement: valid_attributes, api_key: device.api_key
          end.to change(Measurement, :count).by(1)
        end

        it "returns a status code" do
          post :create, measurement: valid_attributes, api_key: device.api_key
          expect(response.status).to eql(200)
          body = HashWithIndifferentAccess.new(JSON.parse(response.body))
          expect(body["status"]).to eql("ok")
        end
      end
    end

    describe "with invalid params" do
      it "returns errors" do
        post :create, measurement: invalid_attributes, api_key: device.api_key
        expect(response.status).to eql(500)
        body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expect(body["error"]).to include("P2 ratio moet opgegeven zijn")
      end
    end
  end
end
