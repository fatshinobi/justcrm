json.array!(@people) do |person|
  json.extract! person, :id, :name, :about, :ava, :phone, :email, :facebook, :twitter, :condition, :group_list
end
