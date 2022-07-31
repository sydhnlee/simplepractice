# TODO: Seed the database according to the following requirements:
# - There should be 10 Doctors with unique names
# - Each doctor should have 10 patients with unique names
# - Each patient should have 10 appointments (5 in the past, 5 in the future)
#   - Each appointment should be 50 minutes in duration

DOCTORS = 10
PATIENTS_PER_DOCTOR = 10
APPOINTMENTS_PER_PATIENT = 10
PATIENTS = DOCTORS * PATIENTS_PER_DOCTOR
APPOINTMENTS = APPOINTMENTS_PER_PATIENT * PATIENTS_PER_DOCTOR # Number of appointments with unique start_time(s)
DOCTOR_NAMES = ['Strange', 'Toboggan', 'Who', 'Doom', 'Frankenstein', 'Dolittle', 'Xavier', 'Octavious', 'Mario', 'Eggman']
FIRST_NAMES = [
    'Sydney', 'Charlie', 'Julien', 'Peter', 'Samuel',
    'Sean', 'Henry', 'George', 'Chris', 'John',
    'Josh', 'James', 'Anna', 'Akira', 'Alison',
    'Joyce', 'Grace', 'Jack', 'Remy', 'Elizabeth'
]
MIDDLE_INITIALS = (65..90).map { |x| x.chr + '.'}
LAST_NAMES = [
    'Lee', 'Kim', 'Park', 'Garcia', 'Smith', 
    'Miller', 'Slater', 'Clark', 'Waters', 'Florence', 
    'Scott', 'King', 'Nguyen', 'Lao', 'Robinson', 
    'Young', 'Bacon', 'Wright', 'Gray', 'Lopez'
]

patient_names = Set.new()
appointment_dates = Hash.new([])

# Creates 100 unique appointments
# Fills appointment_dates hash with 10 (PATIENTS_PER_DOCTOR) key/value pairs
# Key -> unique patient number for a single doctor (0-9)
# Value -> List of hashes representing the 10 appointments unique to a patient of one doctor (5 in past & future)
(1).upto(APPOINTMENTS) do |a|
    patient_num = a % PATIENTS_PER_DOCTOR

    # Creates half (5) of the appointments with start_time(s) in the past & future
    if a > (APPOINTMENTS / 2)
        appointment_dates[patient_num] += [{start_time: (DateTime.now + (a - (APPOINTMENTS / 2)))}]
    else
        appointment_dates[patient_num] += [{start_time: (DateTime.now - (((APPOINTMENTS / 2) + 1) - a))}]
    end
end

# Creates 10 Doctor objects
DOCTOR_NAMES.each do |x|
    Doctor.create(name: "Dr. #{x}")
end

# Loops until 100 unique patient names have been generated
curr_doc = Doctor.left_outer_joins(:patients).group("doctors.id").having("COUNT(patients) < #{PATIENTS_PER_DOCTOR}").first
while patient_names.length < PATIENTS

    # Generates a name at random 
    # FIRST_NAMES.length * MIDDLE_INITIALS.length * LAST_NAMES.length -> 20 * 26 * 20 -> 10,400 possible unique names
    first = FIRST_NAMES[rand(FIRST_NAMES.length)]
    middle = MIDDLE_INITIALS[rand(MIDDLE_INITIALS.length)]
    last = LAST_NAMES[rand(LAST_NAMES.length)]
    new_name = "#{first} #{middle} #{last}"

    # Creates a new Patient object if the generated patient name is unique 
    if patient_names.add?(new_name)
        new_patient = curr_doc.patients.create(name: new_name)

         # Creates associated Appointment objects for the new Patient by utilizing the appointment_dates hash
        appointments = new_patient.appointments
                        .create_with(doctor_id: curr_doc.id, duration_in_minutes: 50, created_at: DateTime.now, updated_at: DateTime.now)
                        .create(appointment_dates[patient_names.length % PATIENTS_PER_DOCTOR])
        
        # Reassigns curr_doc to a new Doctor object once the patient count for curr_doc reaches PATIENTS_PER_DOCTOR (10)
        if patient_names.length % PATIENTS_PER_DOCTOR == 0
            curr_doc = Doctor.left_outer_joins(:patients).group("doctors.id").having("COUNT(patients) < #{PATIENTS_PER_DOCTOR}").first
        end
    end
end


