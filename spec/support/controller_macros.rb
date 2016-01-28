module ControllerMacros
  def login_user(user = FactoryGirl.create(:user, confirmed_at: Time.now))
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  def login_admin
    @request.env["devise.mapping"] = Devise.mappings[:user]
    admin = FactoryGirl.create(:admin_user, confirmed_at: Time.now)
    sign_in admin
  end
end
