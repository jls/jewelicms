Factory.define :channel do |f|
  f.name 'Blog'
  f.slug 'blog'
  f.is_public true
  f.publishes_to_home_page true
end