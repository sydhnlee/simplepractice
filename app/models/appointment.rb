class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  validates :start_time, presence: true
end
