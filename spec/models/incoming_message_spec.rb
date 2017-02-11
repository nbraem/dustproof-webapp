require "rails_helper"

describe IncomingMessage do
  subject(:incoming_message) { FactoryGirl.build(:incoming_message) }

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

  it do
    should have_db_column(:lost_packets).
      of_type(:integer)
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

  context "from the same device eui within a duplication time frame" do
    it "should be considered a duplicate packet" do
      incoming_message1 = FactoryGirl.create(:incoming_message)
      incoming_message2 = FactoryGirl.build(:incoming_message)
      expect(incoming_message1.new_record?).to be false
      expect(incoming_message2.valid?).to be false
      expect(incoming_message2.errors.full_messages.to_sentence).to eq("This is a duplicate packet.")
    end
  end

  context "from the same device eui outside a duplication time frame" do
    it "should not not be considered a duplicate packet" do
      incoming_message1 = FactoryGirl.create(:incoming_message)
      incoming_message2 = FactoryGirl.build(:incoming_message,
        timestamp: incoming_message1.timestamp + 121.seconds)
      expect(incoming_message1.new_record?).to be false
      expect(incoming_message2.valid?).to be true
    end
  end

  context "from different device eui" do
    it "should not filter out duplicate packets" do
      incoming_message1 = FactoryGirl.create(:incoming_message)
      incoming_message2 = FactoryGirl.build(:incoming_message_with_lora_wireless_things_from_another_device_eui)
      expect(incoming_message1.new_record?).to be false
      expect(incoming_message2.valid?).to be true
    end
  end
end
