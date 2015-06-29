json.array!(@opportunities) do |opportunity|
  json.extract! opportunity, :id, :title, :start, :finish, :description, :stage, :status, :company_id, :person_id
  json.url opportunity_url(opportunity, format: :json)
end
