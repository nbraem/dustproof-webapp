require "rails_helper"

describe IncomingMessage do
  subject(:incoming_message) { FactoryGirl.build(:incoming_message) }

  it { should have_db_index(:identifier) }
  it { should have_db_index(:body) }
  it { should have_db_index(:timestamp) }

  it do
    should have_db_column(:body).
      of_type(:jsonb)
  end

  it do
    should have_db_column(:timestamp).
      of_type(:datetime)
  end

  it do
    should have_db_column(:identifier).
      of_type(:string)
  end

  it "should have a body" do
    expect(incoming_message.valid?).to be true
  end

  it { should validate_presence_of(:timestamp) }

  context "with a valid JSON payload through LoRa" do
    describe "#device_eui" do
      it "should return the device eui" do
        expect(incoming_message.valid?).to be true
        expect(incoming_message.device_eui).to eq("DEVICE_EUI")
      end
    end
  end

  context "with a valid JSON payload through WiFi" do
    it "should extract the identifier" do
      incoming_message = FactoryGirl.build(:incoming_message_via_wifi)
      expect(incoming_message.valid?).to be true

      expect(incoming_message.identifier).to eq("API_KEY")
    end
  end
end
