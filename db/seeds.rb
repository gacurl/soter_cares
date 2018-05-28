# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


RelationshipType.create(entanglement: "Sibling", name: "Sibling", male_name: "Brother", female_name: "Sister", male_opposite: "Brother", female_opposite: "Sister")
RelationshipType.create(entanglement: "Child-Parent", name: "Parent-Child", male_name: "Son", female_name: "Daughter", male_opposite: "Father", female_opposite: "Mother")
RelationshipType.create(entanglement: "Grandchild-Grandparent", name: "Grandparent-Grandchild", male_name: "Grandson", female_name: "Granddaughter", male_opposite: "Grandfather", female_opposite: "Grandmother")
RelationshipType.create(entanglement: "Parent-Child", name: "Child-Parent", male_name: "Father", female_name: "Mother", male_opposite: "Son", female_opposite: "Daughter")
RelationshipType.create(entanglement: "Grandparent-Grandchild", name: "Grandchild-Grandparent", male_name: "Grandfather", female_name: "Grandmother", male_opposite: "Grandson", female_opposite: "Granddaughter")
RelationshipType.create(entanglement: "Spouse", name: "Spouse", male_name: "Husband", female_name: "Wife", male_opposite: "Husband", female_opposite: "Wife")
RelationshipType.create(entanglement: "Niece/Nephew-Aunt/Uncle", name: "Aunt/Uncle-Niece/Nephew", male_name: "Nephew", female_name: "Niece", male_opposite: "Uncle", female_opposite: "Aunt")
RelationshipType.create(entanglement: "Aunt/Uncle-Niece/Nephew", name: "Niece/Nephew-Aunt/Uncle", male_name: "Uncle", female_name: "Aunt", male_opposite: "Nephew", female_opposite: "Niece")
RelationshipType.create(entanglement: "Cousin", name: "Cousin", male_name: "Cousin", female_name: "Cousin", male_opposite: "Cousin", female_opposite: "Cousin")
RelationshipType.create(entanglement: "Boyfriend/Girlfriend", name: "Boyfriend/Girlfriend", male_name: "Boyfriend", female_name: "Girlfriend", male_opposite: "Boyfriend", female_opposite: "Girlfriend")
RelationshipType.create(entanglement: "Acquaintance", name: "Acquaintance", male_name: "Friend", female_name: "Friend", male_opposite: "Friend", female_opposite: "Friend")
RelationshipType.create(entanglement: "Same Sex (Unmarried)", name: "Same Sex (Unmarried)", male_name: "Partner", female_name: "Partner", male_opposite: "Partner", female_opposite: "Partner")
RelationshipType.create(entanglement: "Professional Guardian", name: "Professional Guardian", male_name: "Client", female_name: "Client", male_opposite: "Professional Guardian", female_opposite: "Professional Guardian")


ResultType.create(name: "Contract Pending")
ResultType.create(name: "Closed Referral")
ResultType.create(name: "Deceased")
ResultType.create(name: "Discovery Completed")
ResultType.create(name: "Marketing Drip List")
ResultType.create(name: "Followed Up")
ResultType.create(name: "Invoice Sent")
ResultType.create(name: "Left Message")
ResultType.create(name: "Placed at ALF")
ResultType.create(name: "Qualified, OK to pursue")
ResultType.create(name: "Requested more information")
ResultType.create(name: "Seminar Attendee")
ResultType.create(name: "Sent Literature")
ResultType.create(name: "Soter Contract Signed")
ResultType.create(name: "Referred to DAV")
ResultType.create(name: "Placed Semi-Private")
ResultType.create(name: "Placed Private")
ResultType.create(name: "Searching for New ALF")

Position.create(title: "Account Manager")
Position.create(title: "Accountant")
Position.create(title: "Administrative Assistant")
Position.create(title: "Administrator")
Position.create(title: "Analyst")
Position.create(title: "Assistant")
Position.create(title: "Buyer")
Position.create(title: "CEO")
Position.create(title: "Chairman")
Position.create(title: "Consultant")
Position.create(title: "Controller")
Position.create(title: "Customer Service Rep")
Position.create(title: "Director")
Position.create(title: "District Manager")
Position.create(title: "Domestic Partner")
Position.create(title: "Engineer")
Position.create(title: "Executive Vice President")
Position.create(title: "General Manager")
Position.create(title: "Lawyer")
Position.create(title: "Manager")
Position.create(title: "Marketing Manager")
Position.create(title: "Network Administrator")
Position.create(title: "Office Manager")
Position.create(title: "Owner")
Position.create(title: "Owner / Administrator")
Position.create(title: "Partner")
Position.create(title: "President")
Position.create(title: "Product Manager")
Position.create(title: "Project Manager")
Position.create(title: "Purchasing Agent")
Position.create(title: "Purchasing Manager")
Position.create(title: "Receptionist")
Position.create(title: "Recruiter")
Position.create(title: "Regional Manager")
Position.create(title: "Sales Manager")
Position.create(title: "Sales Representative")
Position.create(title: "Supervisor")
Position.create(title: "Technician")
Position.create(title: "Vice President")
Position.create(title: "Vice President of Sales")
Position.create(title: "Webmaster")
Position.create(title: "Nurse Case Manager")
Position.create(title: "Professional Guardian")
Position.create(title: "Private Duty Home Care")
Position.create(title: "Medicare Skilled Home Care")
Position.create(title: "DCF Investigator")
Position.create(title: "Social Worker")
Position.create(title: "Discharge Planner")
Position.create(title: "Hospital Case Manager")
Position.create(title: "Hospital Social Worker")
Position.create(title: "Case Manager")
Position.create(title: "ARNP")
Position.create(title: "Doctor")
Position.create(title: "Certified Nursing Assistant")
Position.create(title: "Physical Therapist")
Position.create(title: "Director of Nursing")
Position.create(title: "Occupational Therapist")
Position.create(title: "Speech Therapist")
Position.create(title: "Registered Nurse (RN)")
Position.create(title: "LPN")
Position.create(title: "Executive Director")

PlacementStatus.create(status: "Hot")
PlacementStatus.create(status: "30 Day")
PlacementStatus.create(status: "60 Day")
PlacementStatus.create(status: "90+ Day")
PlacementStatus.create(status: "Placed")
PlacementStatus.create(status: "Date not set")
PlacementStatus.create(status: "Date selected")

LicenseType.create(name: "Standard")
LicenseType.create(name: "Limited Nursing Services")
LicenseType.create(name: "Extended Congregate Care")
LicenseType.create(name: "Limited Mental")
LicenseType.create(name: "Adult Family Care Home")


CSV.foreach("#{Rails.root}/db/states.csv") do |row|
  state_code = row[0]
  state_name = row[1]
  State.create_with(name: state_name).find_or_create_by!(two_digit_code: state_code)
end

CSV.foreach("#{Rails.root}/db/counties.csv") do |row|
  state_code  = row[0]
  county_name = row[1]
  County.find_or_create_by!(state_id: State.find_by_two_digit_code(state_code).id, name: county_name)
end

CSV.foreach("#{Rails.root}/db/cities.csv") do |row|
  state_two_digit_code = row[0]
  state_id = State.find_by_two_digit_code!(state_two_digit_code).id

  county_name = row[1]
  city_name   = row[2]
  county      = County.find_by_state_id_and_name!(state_id, county_name)
  City.find_or_create_by!(county_id: county.id, name: city_name)
end

CSV.foreach "#{Rails.root}/db/zips.csv" do |row|
  zip_code  = row[0]
  city      = row[1]
  county    = row[2]
  state     = row[3]
  state_id  = State.find_by_two_digit_code!(state).id
  county_id = County.find_by_name_and_state_id!(county, state_id).id
  ZipCode.create_with(city_id: City.find_by_name_and_county_id!(city, county_id).id).find_or_create_by!(code: zip_code)
end