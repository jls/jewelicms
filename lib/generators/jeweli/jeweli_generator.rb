class JeweliGenerator < Rails::Generator::NamedBase
  attr_reader :layout_name
  def initialize(runtime_args, runtime_options = {})
    super
    @layout_name =  name
  end
  
  def manifest
    record do |m|
      # Application layout
      m.file("#{@layout_name}/layout.html.erb", 'app/views/layouts/application.html.erb')
      
      # Database seeds
      m.file("#{@layout_name}/seeds.rb", "db/seeds_#{@layout_name}.rb")
      
      # Images
      Dir[File.join(File.dirname(__FILE__),"templates", @layout_name, "images", "*.*")].sort.each { |i| 
        m.file("#{@layout_name}/images/#{File.basename(i)}", "public/images/#{File.basename(i)}")
      }
      
      # Stylesheets
      Dir[File.join(File.dirname(__FILE__),"templates", @layout_name, "stylesheets", "*.*")].sort.each { |i| 
        m.file("#{@layout_name}/stylesheets/#{File.basename(i)}", "public/stylesheets/#{File.basename(i)}")
      }
      
      # Templates
      Dir[File.join(File.dirname(__FILE__),"templates", @layout_name, "templates", "*.*")].sort.each { |i| 
        m.file("#{@layout_name}/templates/#{File.basename(i)}", "app/views/templates/#{File.basename(i)}")
      }
    end
  end
end