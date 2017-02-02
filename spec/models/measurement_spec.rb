require "rails_helper"

describe Measurement do
  it { should have_db_index(:device_id) }

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

  it { should validate_presence_of(:timestamp) }
  it { should validate_presence_of(:p1_ratio) }
  it { should validate_presence_of(:pm25_ratio) }
  it { should validate_presence_of(:p2_ratio) }

  it { should belong_to(:device) }
end
