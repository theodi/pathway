require 'questionnaire_importer'

namespace :questionnaire do

  desc "Imports questionnaire from survey.xls"
  task :import, [:version,:notes] => :environment do |task, args|
    args.with_defaults(:notes => "Questionnaire import #{Time.now.strftime("%d/%m/%Y %H:%M")}")
    config = File.join( __dir__, "..", "..", "survey", "survey.xls") 
    QuestionnaireImporter.load(args.version.to_i, config, args.notes )
  end
  
  desc "Updates questionnaire from survey.xls"
  task :update, [:version,:notes] => :environment do |task, args|
    config = File.join( __dir__, "..", "..", "survey", "survey.xls") 
    QuestionnaireImporter.update(args.version.to_i, config )
  end
    
end