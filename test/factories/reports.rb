# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    sequence(:title) { |n| "title#{n}" }
    sequence(:content) { |n| "content#{n}" }
    user
  end
end
