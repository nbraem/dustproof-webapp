require "rails_helper"

describe Measurement do
  it { should have_db_index(:user_id) }

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

  it { should validate_presence_of(:timestamp) }
  it { should validate_presence_of(:p1_ratio) }
  it { should validate_presence_of(:pm25_ratio) }
  it { should validate_presence_of(:p2_ratio) }

  it { should validate_presence_of(:p1_concentration) }
  it { should validate_presence_of(:p1_concentration_filtered) }
  it { should validate_presence_of(:p2_concentration) }
  it { should validate_presence_of(:p2_concentration_filtered) }

  it { should belong_to(:user) }

  it "calculates concentration" do
    measurement = FactoryGirl.create(:measurement)
    expect(measurement.valid?).to be true
    expect(measurement.p1_concentration).to eq(322516)
    expect(measurement.p2_concentration).to eq(163797)
  end

  context "with the first measurement" do
    it "calculates filtered concentration" do
      measurement = FactoryGirl.build(:measurement)
      expect(measurement.valid?).to be true
      expect(measurement.p1_concentration_filtered).to eq(322516)
      expect(measurement.p2_concentration_filtered).to eq(163797)
    end
  end

  context "with subsequent measurements" do
    it "calculates filtered concentration" do
      user = FactoryGirl.create(:user)
      measurement = FactoryGirl.create(:measurement,
                                        user: user,
                                        timestamp: Time.now - 5.minutes)
      second_measurement = FactoryGirl.build(:measurement,
                                              user: user,
                                              p1_ratio: 3.5,
                                              p2_ratio: 1.45)

      expect(second_measurement.valid?).to be true
      expect(second_measurement.p1_concentration_filtered).to eq(317832)
      expect(second_measurement.p2_concentration_filtered).to eq(160850)
    end
  end
end
