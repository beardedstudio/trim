namespace :trim do

  namespace :navs do
    desc "Regenerate expected navs"
    task :rebuild => :environment do
      nav_results = Trim::Nav.rebuild_navs!
      nav_results.each do |result|
        if result[:saved]
          puts "#{result[:nav].title} was saved."
        else
          puts "#{result[:nav].title} was not saved."
        end
      end
    end
  end

end