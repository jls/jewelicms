# Lookup the data field types
rich_field_type = DataFieldType.find_by_name('Rich Text')
text_field_type = DataFieldType.find_by_name('Text')

# Lookup the admin user
admin_user = User.find_by_login('admin')

# Create the blog channel
unless blog_channel = Channel.find_by_slug('blog')
  blog_channel = Channel.create(:name => 'blog', :slug => 'blog', :is_public => true)
end

# Create the data fields for the blog channel.
unless summary_field = DataField.find_by_label('summary')
  summary_field = blog_channel.data_fields.create(:label => 'summary', :data_field_type => rich_field_type)
end

unless body_field = DataField.find_by_label('body')
  body_field = blog_channel.data_fields.create(:label => 'body', :data_field_type => rich_field_type)
end

# Create the categories for the Channel
unless general_category = Category.find_by_name_and_channel_id('general', blog_channel.id)
  general_category = blog_channel.categories.create(:name => 'general', :slug => 'general')
end
unless tutorial_category = Category.find_by_name_and_channel_id('tutorials', blog_channel.id)
  tutorial_category = blog_channel.categories.create(:name => 'tutorials', :slug => 'tutorials')
end
unless news_category = Category.find_by_name_and_channel_id('news', blog_channel.id)
  news_category = blog_channel.categories.create(:name => 'news', :slug => 'news')
end

# Create the article for the blog channel
unless article = Article.find_by_slug('a-rails-blog-in-15-minutes')
  article = blog_channel.articles.create(:title => 'A Rails blog in 15 minutes', :slug => 'a-rails-blog-in-15-minutes', :author => admin_user, :is_published => true)
end

# Create article category
article.categories << tutorial_category unless article.categories.include? tutorial_category

# Create the data field values for the article
unless summary_value = DataValue.find_by_article_id_and_data_field_id(article.id, summary_field.id)
  summary_value = article.data_values.create(:data_field_id => summary_field.id, :data_value => "The Jewely project leverages <a href=\"http://rubyonrails.org\">Ruby on Rails</a> to be powerful but simple. Here\'s how to install and run Jewely quickly.")
end

unless body_value = DataValue.find_by_article_id_and_data_field_id(article.id, body_field.id)
  body_value = article.data_values.create(:data_field_id => body_field.id, :data_value => <<eos)
    <h3>Part 1: Prerequisites</h3>
    <p>To run Jewely locally for making your blog successfully you need:</p>
    <ul>
    <li><a href="http://rubyonrails.org">Ruby on Rails</a> (version 2.3.8... the version is <strong>important</strong>)</li>
    <li><a href="http://www.google.com/search?q=installing+git">Git</a></li>
    </ul>
    <p>And to run your Jewely blog online, you will need some kind of Rails-based host or server. We will assume you don't have this and recommend free <a href="http://heroku.com">Heroku</a>.

    <h3>Part 2: Setup</h3>
    <p>Open up your command line and do the following commands. You may or may not want to browse to a fresh directory first.</p>

    <ol>
    <li><code>git clone git@github.com:/jls/jewely.git</code></li>
    <li><code>cd jewely</code></li>
    <li><code>cp config/database.yml.template config/database.yml</code></li>
    <li><code>rake db:setup</code></li>
    <li><code>sudo rake gems:install</code></li>
    <li><code>rake db:setup</code></li>
    </ol>

    <p>You are technically ready to go now, but for this tutorial we want to install an example site. So do this:</p>

    <ol>
    <li><code>script/generate jewely jewelycms.com</code></li>
    </ol>

    <p>If this prompts you with a question, respond with the prompt by typing "Y". Then run to fill your site with data:</p>

    <ol>
    <li><code>rake jewely:load site=jewelycms.com</code></li>
    </ol>

    <p>That's it for setup! Now run your server:</p>
    <ol>
    <li><code>script/server</code></li>
    </ol>

    <p>Verify this worked by browsing to <a href="http://localhost:3000">http://localhost:3000</a>. To stop the server, do a <strong>Ctrl+C</strong> in the terminal window.</p>

    <h3>Part 3: Administrator Panel</h3>
    <p>Browse to <a href="http://localhost:3000/admin">http://localhost.com/admin:3000</a>. Log in with username <strong>admin</strong> and password <strong>jewely</strong>. You can and should change these defaults.</p>

    <p>The seed command you ran gave you all of the content (articles, channels, categories, etc) for the site you're reading right now: jewelycms.com.</p>

    <p>Browse around the interface and notice the hints which you can turn off as indicated. Below is the terminology Jewely uses. </p>

    <p>An <strong>article</strong> is a post you make e.g. "5 cool card tricks". A <strong>channel</strong> is a pre-planned place you'll make articles e.g. "blog", "portfolio" and so on. A <strong>data field</strong> is a field you see when making <strong>article</strong> like "body". A <strong>category</strong> is an optional tag you use to help categgorize your articles "Funny" etc.</p>

    <h3>Part Final: Editing the Look</h3>
    <p>This is the fun part. Open the jewely directory in your favorite text editor (mine is <a href="http://textmate.com">TextMate</a>).</p>

    <h4>Stylesheets</h4>
    <p>The stylesheets which are referenced in the jewelycms.com's starter template view files is</p>
    <ul>
    <li><strong>/jewely/public/stylesheets/reset.css</strong>: contains reset styles. You can safely reuse this for most projects or find your own reset</li>
    <li><strong>/jewely/public/stylesheets/master.css</strong>: contains the core styles. If you clear this file... you can see the html without makeup.</li>
    </ul>

    <p>The Rails views (analogous to html files... which determine your structural layout) are located in <strong>/jewely/app/views/templates/</strong>. This <strong>templates</strong> directory is where you can write your own pages. For example if you want to have a page http://localhost:3000/monkey, you would create a new page <strong>monkey.html.erb</strong> in this directory.</p>
    <ul>
    <li><strong>/jewely/app/views/templates/about.html.erb</strong>: the page that contains some information about JewelyCMS. Replace this with your own text</li>
    <li><strong>/jewely/app/views/templates/archive.html.erb</strong>: lists out all articles. Look around the code to see the loop that is used.</li>
    <li><strong>/jewely/app/views/templates/index.html.erb</strong>: the home page. Check out the code for comments.</li>
    <li><strong>/jewely/app/views/templates/read.html.erb</strong>: the page that displays a single blog article. Expects a url slug after it to work e.g. http://localhost:3000/read/how-to-make-turtles-cry</li>
    </ul>

    <h3>Closing thoughts</h3>
    <p>Keep changing things in the starter site, then refreshing to see the changes. Read the comments that we've written in order to make you understand what the Jewely functions are doing.</p>

    <p>As you can see, Jewely's aim is to step out of your design's way and let you leverage the inherit strengths of Rails. If you have no Rails experience, then the jewely starter commands are a good way to not only accomplish your designs quickly but also <strong>learn some Rails</strong>. Before you know it, you'll be forking Jewely like a drunken hacker!</p>

    <p>Once you've mastered the ins-and-outs of the basic Jewely approach, start making your own pages and own CSS. Or try another jewely starter site with other Jewely seed commands.</p>
eos
end