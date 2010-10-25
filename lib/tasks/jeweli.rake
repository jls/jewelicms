namespace :jeweli do
  desc 'Seeds your Jeweli install database'
  task :load => :environment do
    if ENV['site'] 
      seed_file = File.join(RAILS_ROOT, 'db', "seeds_#{ENV['site']}.rb")
    end
    generate_script = File.join(RAILS_ROOT, 'script', 'generate')
    #puts #{generate_script} jeweli #{ENV['site']}
    Rake::Task["db:seed"].invoke
    load(seed_file) if seed_file
  end  
end