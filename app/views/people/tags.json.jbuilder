json.array!(@tags) do |tag|
  json.extract! tag, :name, :taggings_count
end