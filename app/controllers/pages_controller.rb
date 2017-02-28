class PagesController < ApplicationController
  caches_page :home, :about, :guidelines, :how
  skip_before_action :authenticate_user!, except: :dust_level

  def dust_level
    render layout: false
  end
end
