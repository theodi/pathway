FactoryGirl.define do

  factory :assessment do
    user nil
    start_date "2014-12-10 11:07:10"
    completion_date "2014-12-17 11:07:10"
    title "2014 Q3 Assessment"
    notes "This is a test assessment"
  end

  factory :unfinished_assessment, class: Assessment do
    user nil
    start_date "2015-02-10 11:07:10"
    completion_date nil
    title "2014 Q4 Assessment"
    notes "This is another test assessment, I'm not done yet."
  end

  factory :assessment2, class: Assessment do
    user
    start_date "2014-12-10 11:07:10"
    completion_date "2014-12-17 11:07:10"
    title "2014 Q3 Assessment"
    notes "This is a test assessment"
  end

  factory :assessment3, class: Assessment do
    start_date "2014-12-10 11:07:10"
    completion_date "2014-12-17 11:07:10"
    title "2014 Q3 Assessment"
    notes "This is a test assessment"
    association :user, factory: :country_organisation_user
  end
  factory :assessment4, class: Assessment do
    start_date "2014-12-10 11:07:10"
    completion_date "2014-12-17 11:07:10"
    title "2014 Q3 Assessment"
    notes "This is a test assessment"
    association :user, factory: :country_organisation_user
  end
  factory :assessment5, class: Assessment do
    start_date "2014-12-10 11:07:10"
    completion_date "2014-12-17 11:07:10"
    title "2014 Q3 Assessment"
    notes "This is a test assessment"
    association :user, factory: :country_organisation_user
  end
  factory :assessment6, class: Assessment do
    start_date "2014-12-10 11:07:10"
    completion_date "2014-12-17 11:07:10"
    title "2014 Q3 Assessment"
    notes "This is a test assessment"
    association :user, factory: :country_organisation_user
  end

end
