json.extract! @person, :id, :name, :about, :phone, :facebook, :twitter, :web, :email, :ava, :user_id, :condition

json.companies @person.company_people do |link|
  json.id link.id
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
  json.company appointment.company, :id, :name
end

json.opportunities @person.opportunities do |opportunity|
  json.id opportunity.id
  json.title opportunity.title
  json.description opportunity.description
  json.start opportunity.start.strftime('%m/%d/%Y')
  json.finish opportunity.finish.strftime('%m/%d/%Y')
  json.stage opportunity.stage
  json.status opportunity.status
  json.amount opportunity.amount
  json.user opportunity.user, :id, :name
  json.company opportunity.company, :id, :name
end