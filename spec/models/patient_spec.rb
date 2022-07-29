RSpec.describe Patient do

  it "creates a patient" do
    doctor = FactoryBot.create(:doctor, name: "Dr. One")
    expect { FactoryBot.create(:patient, name: "Patient Zero", doctor: doctor) }
      .to change(Patient, :count).by(1)
  end
end
