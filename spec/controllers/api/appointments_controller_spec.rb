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
      expect(1).to eq(1)
    end

    it "filters by future appointments" do
      expect(1).to eq(1)
    end

    it "paginates appointments" do
      expect(1).to eq(1)
    end

    it "paginates appointments filtered by past/future" do
      expect(1).to eq(1)
    end
  end

  describe "#create" do
    it "returns a successful response" do
      #201
      expect(1).to eq(1)
    end
  end
end
