class Api::V1::MeasurementsController < Api::V1::BaseController

  def index
    measurements = current_user.measurements.order("timestamp asc").limit(120)

    render(
      json: ActiveModel::ArraySerializer.new(
        measurements,
        each_serializer: Api::V1::MeasurementSerializer,
        root: 'measurements',
      )
    )
  end

  def create
    measurement = current_user.measurements.new(measurement_params.merge({timestamp: Time.now}))
    if measurement.save
      render json: { status: 'ok' }, status: 200
    else
      render json: { error: measurement.errors.full_messages.to_sentence }, status: 500
    end
  end

  private

  def measurement_params
    params.
      require(:measurement).
      permit(:seq,
             :humidity,
             :temperature,
             :timestamp,
             :p1_concentration,
             :p1_filtered,
             :p1_lpo,
             :p1_ratio,
             :p2_concentration,
             :p2_filtered,
             :p2_lpo,
             :p2_ratio)
  end
end
