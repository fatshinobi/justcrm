json.array!(@companies) do |company|
  json.extract! company, :id, :name, :about, :phone, :web
  json.url company_url(company, format: :json)
end
