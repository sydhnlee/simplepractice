RSpec.describe Api::DoctorsController do
  describe "#index" do
    it "returns all doctors that do not have an appointment" do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
