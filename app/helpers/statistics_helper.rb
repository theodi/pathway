module StatisticsHelper

  def heatmap_colour(value)
    ["none", "v-low", "low", "medium", "high", "v-high"][value]
  end
   
  def percentage(count, results)
    return count / results[:completed] * 100
  end
   
  def create_public_scores(dimensions, scores)
    data = {
      completed: scores[:completed],
      organisations: scores [:organisations],
      themes: {},
      level_names: ["Initial", "Repeatable", "Defined", "Managed", "Optimising"]
    }
    dimensions.each do |dimension|
      data[:themes][dimension.title] = {}
      dimension.activities.each do |activity|
        data[:themes][dimension.title][activity.title] = scores[:activities][activity.name]
      end
    end
    return data
  end
  
  def create_csv(dimensions, scores)
    data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
      csv << ["Theme", "Activity", "1-Initial", "2-Repeatable", "3-Defined", "4-Managed", "5-Optimising", "Completed", "Organisations"]
      dimensions.each do |dimension|
        dimension.activities.each do |activity|
          csv << [ dimension.title, activity.title ] + scores[:activities][activity.name] + [scores[:completed], scores[:organisations]]
        end
      end
    end
    return data
  end
    
  def create_summary_csv(summary)
    data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
      csv << ["Statistic", "Value"]
      csv << ["Registered Users", summary[:registered_users]]
      csv << ["data.gov.uk organisations", summary[:organisations][:datagovuk] ]
      csv << ["Total Organisations", summary[:organisations][:total] ]          
      csv << ["Organisations with users", summary[:organisations][:total_with_users] ]
      csv << ["Completed assessments", summary[:assessments][:completed] ]
      csv << ["Total assessments", summary[:assessments][:total] ]
      csv << ["Questionnaire version", summary[:questionnaire_version] ]
    end
    return data
  end
  
end