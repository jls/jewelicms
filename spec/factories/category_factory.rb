Factory.define :category do |f|
  f.name 'General'
  f.slug 'general'
  f.association :channel
end