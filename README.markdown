## Quickstart

    git clone http://github.com/jls/jewelycms.git
    cd jewelycms
    cp config/database.yml.template config/database.yml
    sudo rake gems:install
    rake db:setup
    
This will clone the Jewely repository, setup the database and give you a fresh install ready to go. 

## Blog in 15 Minutes Tutorial

A tutorial to get a blog up and running on Jewely in 15 minutes.  This will walk you through every step needed to recreate [jewelycms.com](http://jewelycms.com).

[http://jewelycms.com/read/a-rails-blog-in-15-minutes](http://jewelycms.com/read/a-rails-blog-in-15-minutes)

## Setting up Akismet Spam Service

*  Copy `config/initializers/rakismet.rb.template` to `config/initializers/rakismet.rb`

*  Akismet requires an API key from WordPress.  You can get the API key here: [http://wordpress.com/api-keys/](http://wordpress.com/api-keys/).  

*  Once you have the API key follow the directions in `config/initializers/rakismet.rb`.

