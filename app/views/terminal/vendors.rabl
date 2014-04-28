collection @service_types

attributes :id, :title

child :vendors do
  attributes :id, :title, :commission, :regexp
  child :tariff_templates do
    attributes :id, :title
  end
end

