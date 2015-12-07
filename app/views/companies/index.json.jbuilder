json.array!(@companies) do |company|
  json.extract! company, :id, :name, :about, :phone, :web, :condition, :group_list, :ava
end
