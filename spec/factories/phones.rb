FactoryGirl.define do
  factory :phone do
    # this tells FG to create a new Contact on the fly for this phone to belongs to, if none was passed
    association :contact

    phone '123-456-7890'

    factory :home_phone do
      phone_type 'home'
    end

    factory :work_phone do
      phone_type 'work'
    end

    factory :mobile_phone do
      phone_type 'mobile'
    end
  end
end
