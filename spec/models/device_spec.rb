require "rails_helper"

describe Device do
  it { should have_db_index(:user_id) }

  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:api_key).of_type(:string) }
  it { should have_db_column(:device_eui).of_type(:string) }
  it { should have_db_column(:transport).of_type(:string) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:transport) }

  it { should belong_to(:user) }
  it { should have_many(:measurements) }
end
