FactoryGirl.define do
  factory :account do
    sequence(:company_name) {|n| "Account #{n}" }
    sequence(:subdomain)    {|n| "account_#{n}" }
    after(:create) {|account| Account.current_id  = account.id }
  end

  factory :proposal do
    sequence(:description)   {|n| "New Proposal #{n}" }
    sequence(:customer_name) {|n| "Customer #{n}" }
  end

  factory :user do
    first_name             { %w[Jon Jordan Greg Mike].sample }
    last_name              { %w[Northway Byron Brown Wu].sample }
    sequence(:email)       {|n| "user_#{n}@pitch.dev" }
    password               "placeholder"
    password_confirmation  "placeholder"
  end
end
