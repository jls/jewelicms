namespace :jeweli do
  desc 'Seeds your Jeweli install database'
  task :load => :environment do
    if ENV['site'] 
      seed_file = Rails.root.join('db', "seeds_#{ENV['site']}.rb")
    end
    #generate_script = Rails.root('script', 'generate')
    #puts #{generate_script} jeweli #{ENV['site']}
    Rake::Task["db:seed"].invoke
    load(seed_file) if seed_file
  end  
end