module StatisticsHelper

  def heatmap_colour(value)
    ["none", "v-low", "low", "medium", "high", "v-high"][value]
  end

  def percentage(count, results)
    return (count.to_f / results[:completed].to_f * 100).to_i
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
    end if scores[:completed] >= ODMAT::Application::HEATMAP_THRESHOLD
    return data
  end

  def create_csv(dimensions, scores)
    data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
      csv << ["Theme", "Activity", "1-Initial", "2-Repeatable", "3-Defined", "4-Managed", "5-Optimising", "Completed", "Organisations"]
      dimensions.each do |dimension|
        dimension.activities.each do |activity|
          csv << [ dimension.title, activity.title ] + scores[:activities][activity.name] + [scores[:completed], scores[:organisations]]
        end
      end if scores[:completed] >= ODMAT::Application::HEATMAP_THRESHOLD
    end
    return data
  end
  
  def create_country_csv_header() 
    data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
      csv << ["Country", "Theme", "Activity", "1-Initial", "2-Repeatable", "3-Defined", "4-Managed", "5-Optimising", "Completed", "Organisations"]
    end
    return data
  end
  
  def create_country_csv_row(country, dimensions, scores) 
    data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
      Questionnaire.current.dimensions.each do |dimension|
        dimension.activities.each do |activity|       
          csv << [ country, dimension.title, activity.title ] + scores["themes"][dimension.title][activity.title] + [scores["completed"], scores["organisations"]]
        end
      end
    end
    return data
  end

  def create_summary_csv(summary)
    data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
      csv << ["Statistic", "Value"]
      csv << ["Registered users", summary[:registered_users]]
      csv << ["data.gov.uk organisations", summary[:organisations][:datagovuk] ]
      csv << ["Total organisations", summary[:organisations][:total] ]
      csv << ["Users with organisations", summary[:organisations][:total_with_users] ]
      csv << ["Completed assessments", summary[:assessments][:completed] ]
      csv << ["Total assessments", summary[:assessments][:total] ]
      csv << ["Questionnaire version", summary[:questionnaire_version] ]
    end
    return data
  end

  def create_country_summary_data(country,completed)
    return {
        country: country.name,
        registered_users:  country.users.count,
        users_with_organisations: country.users_with_organisations.count,
        assessments: {
          completed: completed,
          total: country.assessments.count
        },
        questionnaire_version: Questionnaire.current.version
    }
  end

  def create_no_country_summary_data()
    return {
        country: "Not specified",
        registered_users:  User.with_no_country.count,
        users_with_organisations: User.organisational_users.with_no_country.count,
        assessments: {
          completed: Assessment.users_with_no_country.completed.count,
          total: Assessment.users_with_no_country.count
        },
        questionnaire_version: Questionnaire.current.version
    }
  end

  def create_other_country_summary_data(other)
    return {
        country: "All other countries",
        registered_users:  other[:registered_users],
        users_with_organisations: other[:users_with_organisations],
        assessments: {
          completed: other[:assessments][:completed],
          total: other[:assessments][:total]
        },
        questionnaire_version: other[:questionnaire_version]
    }
  end

  def create_country_summary_csv(country_summary)
    data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
      csv << ["Country", "Registered Users", "Organisations With Users", "Completed Assessments","Total Assessments","Questionnaire Version"]
      country_summary.each do |cs|
        csv << [cs[:country],cs[:registered_users],cs[:users_with_organisations],cs[:assessments][:completed],cs[:assessments][:total],cs[:questionnaire_version]]
      end
    end
    return data
  end

end
