FactoryBot.define do
  factory :appointment do
    doctor { create(:doctor) }
    patient { create(:patient) }
    start_time { Time.zone.now }
    duration_in_minutes { 50 }
    
    trait :past do
      start_time {1.week.ago}
    end

    trait :future do
      start_time {1.week.from_now}
    end
  end
end
