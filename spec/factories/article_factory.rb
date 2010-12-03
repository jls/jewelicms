Factory.define :article do |f|
  f.title 'An article'
  f.slug 'an-article'
  f.comments_enabled false
  f.is_published false
  f.association :channel
  f.association :author, :factory => :user
end