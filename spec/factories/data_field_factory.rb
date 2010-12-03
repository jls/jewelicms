Factory.define :data_field do |f|
  f.label 'Summary'
  f.association :channel
  f.association :data_field_type
  f.association :default_filter, :factory => :filter
end