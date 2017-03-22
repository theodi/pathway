FactoryGirl.define do
  factory :country do
    name "United Kingdom"
    code "gb"
  end

  factory :country1, class: Country do
    name "United States"
    code "us"
  end

  factory :country2, class: Country do
    name "Australia"
    code "au"
  end

  factory :country3, class: Country do
    name "Uruguay"
    code "uy"
  end

  factory :country4, class: Country do
    name "United Arab Emirates"
    code "ae"
  end

  factory :country5, class: Country do
    name "New Zealand"
    code "nz"
  end

end
