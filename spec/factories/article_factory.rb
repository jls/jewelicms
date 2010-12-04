Factory.define :article do |f|
  f.sequence(:title) {|n| 
    "An Article #{n}"
  } 
  f.sequence(:slug) {|n| 
    "an-article-#{n}"
  }
  f.comments_enabled false
  f.is_published true
  f.association :channel
  f.association :author, :factory => :user
end