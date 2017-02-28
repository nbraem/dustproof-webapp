require "rails_helper"

describe User do
  [:email, :reset_password_token].each do |column_name|
    it do
      should have_db_index(column_name).unique
    end
  end

  it do
    should have_db_column(:first_name).
      of_type(:string)
  end

  it do
    should have_db_column(:last_name).
      of_type(:string)
  end

  it do
    should have_db_column(:admin).
      of_type(:boolean).
      with_options(default: false, null: false)
  end

  it { should have_many(:devices) }

  it_behaves_like "an Object with a full_name accessor"
end
