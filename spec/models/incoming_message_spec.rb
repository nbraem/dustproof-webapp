require "rails_helper"

describe IncomingMessage do
  subject(:incoming_message) { FactoryGirl.build(:incoming_message) }

  it do
    should have_db_column(:body).
      of_type(:text)
  end

  it do
    should have_db_column(:status).
      of_type(:string)
  end

  it do
    should have_db_column(:gateway_eui).
      of_type(:string)
  end

  it do
    should have_db_column(:device_eui).
      of_type(:string)
  end

  it do
    should have_db_column(:timestamp).
      of_type(:datetime)
  end

  it do
    should have_db_column(:tmst).
      of_type(:string)
  end

  it do
    should have_db_column(:frequency).
      of_type(:float)
  end

  it do
    should have_db_column(:data_rate).
      of_type(:string)
  end

  it do
    should have_db_column(:rssi).
      of_type(:float)
  end

  it do
    should have_db_column(:snr).
      of_type(:float)
  end

  it do
    should have_db_column(:data).
      of_type(:text)
  end

  it do
    should have_db_column(:packet_time).
      of_type(:string)
  end

  it do
    should have_db_column(:comments).
      of_type(:text)
  end

  it do
    should have_db_column(:transport).
      of_type(:string)
  end

  it "should have a body" do
    expect(incoming_message.valid?).to be true
  end

  it { should validate_presence_of(:timestamp) }

  context "with a valid JSON payload through Lora" do
    it "should extract the transport" do
      incoming_message = FactoryGirl.build(:incoming_message)
      expect(incoming_message.valid?).to be true

      expect(incoming_message.status).to eq("processed")
      expect(incoming_message.transport).to eq("lora")
    end
  end

  context "with a valid JSON payload through WiFi" do
    it "should extract the transport" do
      incoming_message = FactoryGirl.build(:incoming_message_via_wifi)
      expect(incoming_message.valid?).to be true

      expect(incoming_message.status).to eq("processed")
      expect(incoming_message.transport).to eq("wifi")
    end
  end

  context "with a valid JSON payload" do
    it "should extract Lora data" do
      incoming_message = FactoryGirl.build(:incoming_message)
      expect(incoming_message.valid?).to be true

      expect(incoming_message.status).to eq("processed")
      expect(incoming_message.gateway_eui).to eq("GATEWAY_EUI")
      expect(incoming_message.device_eui).to eq("DEVICE_EUI")
      expect(incoming_message.packet_time).to eq("2016-03-14T11:51:19.783817Z")
      expect(incoming_message.tmst).to eq("3969010612")
      expect(incoming_message.frequency).to eq(868.1)
      expect(incoming_message.data_rate).to eq("SF12BW125")
      expect(incoming_message.rssi).to eq(-120)
      expect(incoming_message.snr).to eq(-14.2)
      expect(incoming_message.data).to eq("000d012f0016003b000526fc26fc")
    end
  end

  context "with an invalid JSON payload" do
    it "should indicate a json_parse error" do
      incoming_message = FactoryGirl.build(:incoming_message, body: "foobar")
      expect(incoming_message.valid?).to be true

      expect(incoming_message.status).to eq("json_parse_error")
    end
  end

  context "with an invalid Lora payload" do
    it "should indicate a decode error" do
      incoming_message = FactoryGirl.build(:incoming_message_with_invalid_lora_data)
      expect(incoming_message.valid?).to be true
      expect(incoming_message.data).to eq("Decode error.")
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
      incoming_message2 = FactoryGirl.build(:incoming_message_with_lora_data_from_another_device_eui)
      expect(incoming_message1.new_record?).to be false
      expect(incoming_message2.valid?).to be true
    end
  end
end
