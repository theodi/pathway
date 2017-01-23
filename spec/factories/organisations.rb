FactoryGirl.define do

  factory :organisation do
    title "Department for Environment, Food and Rural Affairs"
    name "department-for-environment-food-and-rural-affairs"
    dgu_id "a7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation1, class: Organisation do
    title "Department for Rural"
    name "department-for-environment-food-and-rural-affairs"
    dgu_id "a7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation2, class: Organisation do
    title "Organisation for Environment, Food Affairs"
    name "organisation-for-environment-food-and-rural-affairs"
    dgu_id "b7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation3, class: Organisation do
    title "Organisation for Environment"
    name "organisation-for-environment-food-and-rural-affairs"
    dgu_id "b7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation4, class: Organisation do
    title "Organisation for Rural Affairs"
    name "organisation-for-environment-food-and-rural-affairs"
    dgu_id "b7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation5, class: Organisation do
    title "Organisation for Food and Rural Affairs"
    name "organisation-for-environment-food-and-rural-affairs"
    dgu_id "a7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation6, class: Organisation do
    title "Organisation for Affairs"
    name "organisation-for-affairs"
    dgu_id "d7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation7, class: Organisation do
    title "Organisation"
    name "organisation"
    dgu_id "d7059f6a-8fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  sequence :title do |n|
    "Organisation#{n}"
  end

  sequence :name do |n|
    "Organisation_name#{n}"
  end

  sequence :dgu_id do |n|
    "d7059f6a-8fb4-4e0f-9c7a-8cd9079780#{n}"
  end

  factory :organisation8, class: Organisation do
    title
    name
    dgu_id
    parent nil
  end

  factory :organisation9, class: Organisation do
    title "Organised for Affairs"
    name "organised-for-affairs"
    dgu_id "d4359f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation_dgu, class: Organisation do
    title "All data.gov.uk organisations"
    name "all-data-gov-uk-organisations"
    dgu_id "c4359f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation_all, class: Organisation do
    title "All Organisations"
    name "all-organisations"
    dgu_id "f4359f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

end
