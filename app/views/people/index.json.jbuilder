json.array!(@people) do |person|
  json.extract! person, :id, :name, :about, :ava, :phone, :email, :facebook, :twitter
  json.url person_url(person, format: :json)
end
