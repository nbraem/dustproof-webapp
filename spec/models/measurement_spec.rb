require "rails_helper"

describe Measurement do
  it { should have_db_index(:device_id) }
  it { should have_db_index(:seq_num) }

  it do
    should have_db_column(:transport).
      of_type(:string)
  end

  it do
    should have_db_column(:temperature).
      of_type(:float)
  end

  it do
    should have_db_column(:humidity).
      of_type(:float)
  end

  it do
    should have_db_column(:timestamp).
      of_type(:datetime)
  end

  it do
    should have_db_column(:pm25_ratio).
      of_type(:float)
  end

  it do
    should have_db_column(:p1_ratio).
      of_type(:float)
  end

  it do
    should have_db_column(:p2_ratio).
      of_type(:float)
  end

  it do
    should have_db_column(:p1_count).
      of_type(:integer)
  end

  it do
    should have_db_column(:p2_count).
      of_type(:integer)
  end

  it do
    should have_db_column(:is_valid).
      of_type(:boolean)
  end

  it do
    should have_db_column(:seq_num).
      of_type(:integer)
  end

  it { should validate_presence_of(:timestamp) }
  it { should validate_presence_of(:p1_ratio) }
  it { should validate_presence_of(:pm25_ratio) }
  it { should validate_presence_of(:p2_ratio) }
  it { should validate_presence_of(:seq_num) }
  it { should validate_presence_of(:loss) }

  it { should belong_to(:device) }

  context "with the same sequence number within a duplication time frame" do
    it "should be considered a duplicate packet" do
      measurement1 = FactoryGirl.create(:measurement, seq_num: 0)
      measurement2 = FactoryGirl.build(:measurement, seq_num: 0, device: measurement1.device)
      expect(measurement1.new_record?).to be false
      expect(measurement2.valid?).to be false
      expect(measurement2.errors.full_messages.to_sentence).to eq("This is a duplicate measurement.")
    end
  end

  context "with the same sequence number outside a duplication time frame" do
    it "should be considered a duplicate packet" do
      measurement1 = FactoryGirl.create(:measurement, seq_num: 0)
      measurement2 = FactoryGirl.build(:measurement, seq_num: 0,
        device: measurement1.device,
        timestamp: measurement1.timestamp + 60.seconds)
      expect(measurement1.new_record?).to be false
      expect(measurement2.valid?).to be false
      expect(measurement2.errors.full_messages.to_sentence).to eq("This is a duplicate measurement.")
    end
  end
end
