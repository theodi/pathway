class QuestionnaireImporter
  
  def self.load(version, config, notes="")
    questionnaire = create_questionnaire(version, notes)    
    book = Spreadsheet.open config
    populate_activities(questionnaire, book.worksheet('activities') )
    populate_answers(questionnaire, book.worksheet('questions') )
    populate_improvements(questionnaire, book.worksheet('improvements') )    
  end

  def self.update(version, config)
    questionnaire = Questionnaire.find_by_version(version)    
    book = Spreadsheet.open config
    populate_activities(questionnaire, book.worksheet('activities') )
    populate_answers(questionnaire, book.worksheet('questions') )
    populate_improvements(questionnaire, book.worksheet('improvements') )
  end
    
  def self.create_questionnaire(version, notes="")
    Questionnaire.create(version: version, notes: notes)
  end
    
  def self.populate_activities(questionnaire, worksheet)
    worksheet.each 1 do |row|
      dimension = Dimension.find_or_create_by(questionnaire_id: questionnaire.id, name: create_slug(row[0]))
      dimension.title = row[0]
      dimension.save
      activity = Activity.find_or_create_by(questionnaire_id: questionnaire.id, dimension_id: dimension.id, name: create_slug(row[1]))
      activity.title = row[1]
      activity.save
    end
  end
  
  def self.populate_answers(questionnaire, worksheet)
    question = nil
    activity = nil
    worksheet.each 1 do |row|
      if !row[0].blank?
        activity = Activity.find_by_name( create_slug( row[2] ) )
        question = Question.find_or_create_by(questionnaire_id: questionnaire.id, code: row[0], activity: activity)
        question.update_attributes( {
          text: row[3],
          notes: row[4],
          dependency_id: row[5].blank? ? nil : Question.find_by_code( row[5] ).id
        })
        question.save
      end
      answer = Answer.find_or_create_by(questionnaire_id: questionnaire.id, question: question, code: row[6])
      answer.update_attributes( {
        text: row[7],
        positive: row[8] == "Y",
        score: row[9].blank? ? nil : row[9].to_i
      })
      answer.save!
    end
  end
  
  def self.populate_improvements(questionnaire, worksheet)
    worksheet.each 1 do |row|
      answer = Answer.find_by_code( row[1] )
      improvement = Improvement.find_or_create_by( answer: answer, code: row[0] )
      improvement.update_attributes({
        notes: row[2]
      })
      improvement.save
    end
  end
    
  def self.create_slug(title)
    title.parameterize
  end
end