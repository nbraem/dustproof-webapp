require "rails_helper"

describe IncomingMessage do
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
end
