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
    dgu_id "b7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

end
