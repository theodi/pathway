FactoryGirl.define do
  factory :country do
    name "United Kingdom"
    code "gb"
  end

  factory :country2, class: Country do
    name "Australia"
    code "au"
  end

  factory :country3, class: Country do
    name "Uruguay"
    code "uy"
  end


end
