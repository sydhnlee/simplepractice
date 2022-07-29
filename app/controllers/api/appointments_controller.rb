class Api::AppointmentsController < ApplicationController
  def index
    # TODO: return all values
    # TODO: return filtered values
    query = Appointment.all

    if params[:length] && params[:page]
      query = query.limit(params[:length].to_i).offset(params[:length].to_i * (params[:page].to_i - 1))
    end

    case params[:past]
      when "0"
        query = query.where("start_time > ?", DateTime.now)
      when "1"
        query = query.where("start_time < ?", DateTime.now)
    end

    key_order = ["id", "patient", "doctor", "created_at", "start_time", "duration_in_minutes"]
    appointments = query.as_json(include: {patient: { only: :name }, doctor: {only: [:name, :id]}}, except: [:updated_at, :doctor_id, :patient_id])
    appointments.map! { |appt| appt["doctor"].slice!(*["name", "id"]); appt.slice(*key_order)}
    render json: appointments
  end

  def create
    # TODO:
    appointment = Appointment.new(patient_id: Patient.find_by(name: params[:patient][:name]).id, doctor_id: params[:doctor][:id], start_time: params[:start_time], duration_in_minutes: params[:duration_in_minutes])
    
    if appointment.save
      render json: {"200": "Success"}
    else
      render json: {"404": "Fail"}
    end
  end
end
