RSpec.describe Api::AppointmentsController do
  describe "#index" do
    it "returns a successful response" do
      get :index
      expect(response.status).to eq(200)
    end

    it "returns json data" do
      get :index
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it "returns correct json structure" do
      FactoryBot.create(:appointment)

      get :index
      appointment_list = JSON.parse(response.body)
      appointment = appointment_list.first()

      expect(appointment.keys).to include(*['id', 'patient', 'doctor', 'created_at', 'start_time', 'duration_in_minutes'])
      expect(appointment['doctor'].keys).to include(*['name', 'id'])
      expect(appointment['patient'].keys).to include(*['name'])
    end

    it "filters by past appointments" do
      FactoryBot.create(:appointment, :past)
      FactoryBot.create(:appointment, :future)

      get :index, params: {past: 1}
      appointment_list = JSON.parse(response.body)

      appointment_list.each do |appt|
        expect(appt["start_time"].to_datetime < DateTime.now).to be true
      end
    end

    it "filters by future appointments" do
      FactoryBot.create(:appointment, :past)
      FactoryBot.create(:appointment, :future)

      get :index, params: {past: 0}
      appointment_list = JSON.parse(response.body)

      appointment_list.each do |appt|
        expect(appt["start_time"].to_datetime > DateTime.now).to be true
      end
    end

    it "paginates appointments" do
      FactoryBot.create_list(:appointment, 10)

      get :index, params: {length: 5, page: 2}
      appointment_list = JSON.parse(response.body)

      expect(appointment_list.length).to eq(5)
    end

    it "paginates appointments filtered by past" do
      FactoryBot.create_list(:appointment, 10, :past)
      FactoryBot.create_list(:appointment, 10, :future)

      get :index, params: {past: 1, length: 5, page: 2}
      appointment_list = JSON.parse(response.body)

      expect(appointment_list.length).to eq(5)
      appointment_list.each do |x|
        expect(x["start_time"].to_datetime < DateTime.now).to be true
      end
    end
  end

  describe "#create" do
    it "creates a new Appointment object" do
      patient = FactoryBot.create(:patient)
  
      expect { post :create, params: { patient: { name: patient.name }, doctor: { id: patient.doctor.id }, start_time: Time.now, duration_in_minutes: 50 } } 
        .to change(Appointment, :count).by(1)
    end
    
    it "returns 201 response upon successful creation" do
      patient = FactoryBot.create(:patient)
      post :create, params: { patient: { name: patient.name }, doctor: { id: patient.doctor.id }, start_time: Time.now, duration_in_minutes: 50 }
      expect(response.status).to eq(201)
    end

    it "returns 400 response upon validation failure" do
      patient = FactoryBot.create(:patient)
      post :create, params: { patient: { name: patient.name }, doctor: { id: patient.doctor.id } }
      expect(response.status).to eq(400)
    end
  end
end
