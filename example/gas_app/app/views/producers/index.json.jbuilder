json.array!(@producers) do |producer|
  json.extract! producer, :id, :name, :address, :email, :phone
  json.url producer_url(producer, format: :json)
end
