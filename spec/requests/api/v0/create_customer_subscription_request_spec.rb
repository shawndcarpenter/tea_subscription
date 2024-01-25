require 'rails_helper'

describe "Sign Up Customer for Tea Subscription API Endpoint" do
  it "creates a customer subscription" do
    create_list(:customer, 3)
    create_list(:subscription, 3)

    subscription = Subscription.first
    customer = Customer.first

    expect(CustomerSubscription.all.length).to eq(0)

    post '/api/v0/customer_subscriptions', params: {subscription_id: subscription.id, customer_id: customer.id }

    expect(response).to be_successful
    expect(CustomerSubscription.all.length).to eq(1)

    response_data = JSON.parse(response.body, symbolize_names: true)

    expect(response_data).to have_key(:message)
    expect(response_data[:message]).to be_a String
    expect(response_data[:message]).to eq("Successfully signed up Customer ##{customer.id} for #{subscription.title}")
  end 
end