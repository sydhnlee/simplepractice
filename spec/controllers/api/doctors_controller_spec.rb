RSpec.describe Api::DoctorsController do
  describe "#index" do
    it "returns a successful response" do
      get :index
      expect(response.status).to eq(200)
    end

    it "returns json data" do
      get :index
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it "returns doctors that do not have an appointment" do
      FactoryBot.create(:appointment) # According to provided factory code, creates two doctors (one with an appointment and one without)

      get :index
      doctor_list = JSON.parse(response.body)

      doctor_list.each do |doc|
        expect(Doctor.find(doc["id"]).appointments.count).to eq(0)
      end
    end
  end
end
