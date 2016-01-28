module Features
  module SessionHelpers
    def sign_in_with(email, password)
      visit new_user_session_path
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      click_button "Inloggen"
    end
  end
end
