Factory.define :data_value do |f|
  f.data_value 'The summary value'
  f.association :filter
  f.association :article
  f.association :data_field
end