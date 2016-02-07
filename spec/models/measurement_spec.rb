require "rails_helper"

describe Measurement do
  it { should have_db_index(:user_id) }

  it do
    should have_db_column(:seq_id).
      of_type(:integer).
      with_options(limit: 8)
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
    should have_db_column(:p1_concentration).
      of_type(:float)
  end

  it do
    should have_db_column(:p1_filtered).
      of_type(:float)
  end

  it do
    should have_db_column(:p1_lpo).
      of_type(:integer).
      with_options(limit: 8)
  end

  it do
    should have_db_column(:p1_ratio).
      of_type(:float)
  end

  it do
    should have_db_column(:p2_concentration).
      of_type(:float)
  end

  it do
    should have_db_column(:p2_filtered).
      of_type(:float)
  end

  it do
    should have_db_column(:p2_lpo).
      of_type(:integer).
      with_options(limit: 8)
  end

  it do
    should have_db_column(:p2_ratio).
      of_type(:float)
  end

  it { should validate_presence_of(:seq_id) }
  it { should validate_presence_of(:timestamp) }
  it { should validate_presence_of(:p1_lpo) }
  it { should validate_presence_of(:p2_lpo) }

  it { should belong_to(:user) }
end
