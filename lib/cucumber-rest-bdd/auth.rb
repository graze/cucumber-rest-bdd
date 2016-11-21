require 'cucumber-api/steps'

Given(/^I am authenticated$/) do
    steps %Q{
      Given I send "application/json" and accept JSON
      And I add Headers:
          | Authorization | Graze C9V3vkEjiLwWVvjpxa5OUtBO3eUKV/SbYFm7R/IaYWo= |
    }
end

Given(/^I am a client$/) do
    steps %Q{
      Given I send "application/json" and accept JSON
    }
end
