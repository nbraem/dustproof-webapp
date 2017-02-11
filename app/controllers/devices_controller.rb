class DevicesController < ApplicationController
  before_action :set_device, only: [:show,
    :edit, :update, :destroy, :regenerate_api_key,
    :dust_level, :destroy_photo]
  before_action :set_common_breadcrumbs, only: [:show, :new, :edit]
  respond_to :html

  def index
    @q = current_user.devices.search(params[:q])
    @q.sorts = "name ASC" if @q.sorts.empty?
    @devices = @q.result(distinct: true).page(params[:page])
    respond_with(@devices)
  end

  def show
    add_breadcrumb @device.name
    @measurements = @device.measurements.where(is_valid: true).order(timestamp: :desc).limit(4000).reverse
    respond_with(@measurements)
  end

  def new
    add_breadcrumb :new
    @device = current_user.devices.new
    respond_with(@device)
  end

  def edit
    add_breadcrumb @device.name, @device
    add_breadcrumb :edit
  end

  def create
    @device = current_user.devices.new(device_params)
    if @device.save
      redirect_to @device
    else
      set_common_breadcrumbs
      add_breadcrumb :new
      render :new
    end
  end

  def update
    if @device.update(device_params)
      redirect_to [:edit, @device], notice: "Wijzigingen met succes bewaard."
    else
      set_common_breadcrumbs
      add_breadcrumb @device.name, @device
      add_breadcrumb :edit
      render :edit
    end
  end

  def regenerate_api_key
    @device.generate_api_key
    @device.save
    redirect_to [:edit, @device], notice: "API key met succes vernieuwd. Vergeet je code niet aan te passen!"
  end

  def destroy_photo
    @device.photo = nil
    @device.save
    redirect_to [:edit, @device], notice: "Foto met succes verwijderd."
  end

  def destroy
    if @device.measurements.any?
      redirect_to @device, alert: t("flash.devices.has_measurements")
    else
      @device.destroy
      redirect_to :devices
    end
  end

  def dust_level
    render layout: false
  end

  private

  def device_params
    params.
      require(:device).
      permit(:name,
             :location,
             :transport,
             :device_eui,
             :public,
             :photo
      )
  end

  def set_device
    @device = current_user.devices.find(params[:id])
  end

  def set_common_breadcrumbs
    add_breadcrumb t("devices.index.title"), :devices
  end
end
