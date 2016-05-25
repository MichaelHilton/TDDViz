json.array!(@cycles) do |cycle|
  json.extract! cycle, :id
  json.url cycle_url(cycle, format: :json)
end
