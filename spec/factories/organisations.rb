FactoryGirl.define do

  factory :organisation do
    title "Department for Environment, Food and Rural Affairs"
    name "department-for-environment-food-and-rural-affairs"
    dgu_id "a7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

  factory :organisation2, class: Organisation do
    title "Organisation for Environment, Food and Rural Affairs"
    name "organisation-for-environment-food-and-rural-affairs"
    dgu_id "b7059f6a-7fb4-4e0f-9c7a-8cd9079780d3"
    parent nil
  end

end
