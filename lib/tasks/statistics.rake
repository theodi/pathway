require 'statistics_generator'

namespace :statistics do
  
  desc "Generates organisation scores for heatmap page"
  task :generate => :environment do
    generator = StatisticsGenerator.new
    
    puts "Generating all orgs"
    generator.generate_stats_for_all_organisations
    
    puts "Generating d.g.u orgs"
    generator.generate_stats_for_dgu_organisations

    puts "Generating all parent groups"
    generator.generate_stats_for_dgu_groups
    
    puts "Done"    
  end
  
end