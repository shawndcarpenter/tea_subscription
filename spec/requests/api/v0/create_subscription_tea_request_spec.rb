require 'rails_helper'

describe "Create Subscription Teas API Endpoint" do
  it "creates a subscription tea" do
    create_list(:tea, 2)
    tea = Tea.first
    tea_2 = Tea.last
    create_list(:subscription, 2)
    subscription = Subscription.first

    expect(SubscriptionTea.all.length).to eq(0)

    post '/api/v0/subscription_teas', params: {subscription_id: subscription.id, tea_id: tea.id }

    expect(response).to be_successful
    expect(SubscriptionTea.all.length).to eq(1)

    subscription_tea = SubscriptionTea.all.first

    expect(subscription_tea.subscription_id).to eq(subscription.id)
    expect(subscription_tea.tea_id).to eq(tea.id)

    response_data = JSON.parse(response.body, symbolize_names: true)

    expect(response_data).to have_key(:message)
    expect(response_data[:message]).to be_a String
    expect(response_data[:message]).to eq("Successfully added #{tea.title} tea to #{subscription.title} subscription")
  end
end