class PagesController < ApplicationController
  skip_before_action :authenticate_user!, except: :dust_level

  def dust_level
    render layout: false
  end
end
