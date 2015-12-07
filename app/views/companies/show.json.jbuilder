json.extract! @company, :id, :name, :about, :phone, :web, :ava, :user_id, :condition

json.group_list @company.group_list.join(', ')

json.people @company.company_people do |link|
  json.id link.id
  json.person link.person, :id, :name, :ava
  json.role link.role
end

json.appointments @company.appointments do |appointment|
  json.id appointment.id
  json.body appointment.body
  json.when appointment.when.strftime('%m/%d/%Y %H:%M:%S')
  json.communication_type appointment.communication_type
  json.status appointment.status
  json.user appointment.user, :id, :name
  json.person appointment.person, :id, :name
end

json.opportunities @company.opportunities do |opportunity|
  json.id opportunity.id
  json.title opportunity.title
  json.description opportunity.description
  json.start opportunity.start.strftime('%m/%d/%Y')
  json.finish opportunity.finish.strftime('%m/%d/%Y')
  json.stage opportunity.stage
  json.status opportunity.status
  json.amount opportunity.amount
  json.user opportunity.user, :id, :name
  json.person opportunity.person, :id, :name
end