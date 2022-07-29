class Api::DoctorsController < ApplicationController
  def index
    # TODO: return all values
    # TODO: return filtered values
    query = Doctor.includes(:appointments).where(appointments: {id: nil})
    render json: query
  end
end
