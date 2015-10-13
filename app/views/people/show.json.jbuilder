json.extract! @person, :id, :name, :about, :phone, :facebook, :twitter, :web, :email, :ava, :created_at, :updated_at

json.companies @person.company_people do |link|
  json.company link.company, :id, :name, :ava
  json.role link.role
end

json.appointments @person.appointments do |appointment|
  json.id appointment.id
  json.body appointment.body
  json.when appointment.when.strftime('%m/%d/%Y %H:%M:%S')
  json.communication_type appointment.communication_type
  json.status appointment.status
  json.user appointment.user, :id, :name
end