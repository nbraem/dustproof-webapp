require "rails_helper"

feature "User authentication flow" do
  let(:user) { FactoryGirl.create(:user, email: "user@example.com", password: "secret", confirmed_at: Time.now) }

  scenario "User signs in with invalid credentials" do
    visit new_user_session_path
    fill_in "user_email", with: "user@example.com"
    fill_in "user_password", with: "wrongpassword"
    click_button "Inloggen"

    expect(page).to have_text("Ongeldige e-mail of wachtwoord.")
  end

  scenario "User signs in with valid credentials" do
    sign_in_with user.email, "secret"

    expect(page).to have_text("dustProof.be")
  end

  scenario "User updates first name in account settings" do
    sign_in_with user.email, "secret"
    visit edit_user_registration_path

    expect(page).to have_css(".page-header", text: "Instellingen")

    fill_in "user_first_name", with: "Jane"
    fill_in "user_last_name", with: "Doe"
    fill_in "user_current_password", with: "secret"
    click_button "Wijzigingen bewaren"

    expect(page).to have_text("Je account gegevens zijn bewaard.")
    expect(user.reload.first_name).to eq("Jane")
  end

  scenario "User resets password" do
    user = FactoryGirl.create(:user, email: "john.doe@example.com", password: "secret", confirmed_at: Time.now)
    visit new_user_password_path
    fill_in "user_email", with: "john.doe@example.com"
    click_button "Stuur mij instructies"
    expect(unread_emails_for(user.email)).to be_present

    open_email user.email, with_subject: "Instructies om nieuw wachtwoord te kiezen"
    visit_in_email "Kies een nieuw wachtwoord"
    expect(page).to have_text("Wachtwoord wijzigen")

    fill_in "user_password", with: "new_secret"
    click_button "Wijzig mijn wachtwoord"
    expect(page).to have_text("Je wachtwoord is gewijzigd.")
  end
end
