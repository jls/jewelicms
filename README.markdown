## Quickstart

    git clone http://github.com/jls/jewelicms.git
    cd jewelicms
    cp config/database.yml.template config/database.yml
    sudo rake gems:install
    rake db:setup
    
This will clone the Jeweli repository, setup the database and give you a fresh install ready to go. 

## Blog in 15 Minutes Tutorial

A tutorial to get a blog up and running on Jeweli in 15 minutes.  This will walk you through every step needed to recreate [jewelicms.com](http://jewelicms.com).

[http://jewelicms.com/read/a-rails-blog-in-15-minutes](http://jewelicms.com/read/a-rails-blog-in-15-minutes)

## Setting up Akismet Spam Service

*  Copy `config/initializers/rakismet.rb.template` to `config/initializers/rakismet.rb`

*  Akismet requires an API key from WordPress.  You can get the API key here: [http://wordpress.com/api-keys/](http://wordpress.com/api-keys/).  

*  Once you have the API key follow the directions in `config/initializers/rakismet.rb`.

