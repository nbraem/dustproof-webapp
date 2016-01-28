require "rails_helper"

feature "User management" do
  let(:admin) { FactoryGirl.create(:admin_user, email: "admin@example.com", password: "secret", confirmed_at: Time.now) }
  let!(:user) { FactoryGirl.create(:user, confirmed_at: Time.now) }

  scenario "admin lists users" do
    sign_in_with admin.email, "secret"
    within(".navbar") { click_link "Gebruikers" }

    expect(page).to have_css(".breadcrumb", text: "Gebruikers")
    expect(page).to have_css(".container", text: "John Doe")
  end

  scenario "admin creates a user" do
    sign_in_with admin.email, "secret"
    visit "/admin/users/new"

    expect(page).to have_css(".page-header", text: "Nieuwe gebruiker")

    fill_in "user_first_name", with: "Davy"
    fill_in "user_last_name", with: "Jones"
    fill_in "user_email", with: "davy.jones@example.com"
    fill_in "user_password", with: "secret"
    click_button "Maak Gebruiker aan"

    expect(page).to have_css(".page-header", text: "Gebruiker")
    expect(page).to have_content("Davy Jones")
  end

  scenario "admin edits a user" do
    sign_in_with admin.email, "secret"
    visit users_path

    within("#users") do
      click_link user.full_name
    end
    click_link "Bewerken"

    expect(page).to have_css(".page-header", text: "Bewerk Gebruiker")

    fill_in "user_first_name", with: "Jane"
    click_button "Wijzigingen bewaren"

    expect(page).to have_css(".page-header", text: "Gebruiker")
    expect(page).to have_content("Jane Doe")
  end

  scenario "admin deletes a user" do
    sign_in_with admin.email, "secret"
    visit users_path

    within("#users") do
      click_link user.full_name
    end
    expect do
      click_link "Verwijderen"
    end.to change(User, :count).by(-1)

    expect(page).to have_css(".breadcrumb", text: "Gebruikers")
  end

  scenario "admin tries to delete own account" do
    sign_in_with admin.email, "secret"
    visit user_path(admin)

    expect do
      click_link "Verwijderen"
    end.to change(User, :count).by(0)

    expect(page).to have_text("Fout: Je kan jezelf niet verwijderen.")
    expect(page).to have_css(".breadcrumb", text: "Gebruikers")
  end
end
