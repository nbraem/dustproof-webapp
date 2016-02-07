class ApiKeyController < ApplicationController
  def regenerate_api_key
    current_user.generate_api_key
    current_user.save
    redirect_to edit_user_registration_path, notice: "API key met succes vernieuwd. Vergeet je code niet aan te passen!"
  end
end
