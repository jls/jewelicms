class JeweliGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :layout_name, :type => :string, :default => 'jewelicms.com'
  
  def generate_layout
  
    # Application layout
    copy_file "#{layout_name}/layout.html.erb", 'app/views/layouts/application.html.erb'
    
    # Database seeds
    copy_file "#{layout_name}/seeds.rb", "db/seeds_#{layout_name}.rb"
    
    # Images
    Dir[File.join(File.dirname(__FILE__),"templates", layout_name, "images", "*.*")].sort.each { |i| 
      copy_file("#{layout_name}/images/#{File.basename(i)}", "public/images/#{File.basename(i)}")
    }
    
    # Stylesheets
    Dir[File.join(File.dirname(__FILE__),"templates", layout_name, "stylesheets", "*.*")].sort.each { |i| 
      copy_file("#{@layout_name}/stylesheets/#{File.basename(i)}", "public/stylesheets/#{File.basename(i)}")
    }
    
    # Templates
    Dir[File.join(File.dirname(__FILE__),"templates", layout_name, "templates", "*.*")].sort.each { |i| 
      copy_file("#{layout_name}/templates/#{File.basename(i)}", "app/views/templates/#{File.basename(i)}")
    }
    
  end
  
end
