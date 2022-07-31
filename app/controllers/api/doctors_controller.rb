class Api::DoctorsController < ApplicationController
  def index
    # TODO: return doctors without appointments
    @query = Doctor.includes(:appointments).where(appointments: {id: nil})
    render json: @query
  end
end
