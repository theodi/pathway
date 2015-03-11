FactoryGirl.define do
  
  factory :assessment do
    user nil
    start_date "2014-12-10 11:07:10"
    completion_date "2014-12-17 11:07:10"
    title "2014 Q3 Assessment"
    notes "This is a test assessment"
  end

  factory :unfinished_assessment do
    user nil
    start_date "2015-02-10 11:07:10"
    completion_date nil
    title "2014 Q4 Assessment"
    notes "This is another test assessment, I'm not done yet."
  end

end
