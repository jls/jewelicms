namespace :jeweli do
  desc 'Creates an article for every file in the supplied directory.'
  task :import_from_directory => :environment do
    dir = ENV['dir']
    channel_slug = ENV['channel']
    category_slug = ENV['category']
    
    if dir.blank? || channel_slug.blank?
      print_help
      abort
    end
    
    channel = Channel.where(:slug => channel_slug).first
    
    unless channel
      puts 'Unknown Channel...aborting.'
      abort
    end
    
    category = channel.categories.where(:slug => category_slug).first
    
    puts "Reading directory..."
    Dir[File.join(dir, "*.*")].sort.each do |i|
      # Check to see if an article already exists
      filename = File.basename(i)
      puts filename
      if channel.articles.where(:title => filename).count > 0
        puts "\tSkipping since matching article already exists"
        next
      end
      puts "\tAdding article"
      article = channel.articles.new_for_channel(channel, :title => filename)
      article.save
      if category
        puts "\tAdding to #{category.name} category"
        article.categories << category
      end
      puts "\tFinished"
    end
    
    puts "Import Complete"
  end  
  
  def print_help
    puts "USAGE: rake jeweli:import_from_directory dir=<directory path and name> channel=<channel slug>"
    puts "\nThis will create 1 article for each of the files in the supplied directory."
    puts "For example, if you had a directory of images this will create an article"
    puts "with the article title set to the filename of each image."
  end

end