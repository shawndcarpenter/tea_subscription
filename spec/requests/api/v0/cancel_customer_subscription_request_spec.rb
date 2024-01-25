require 'rails_helper'

describe "Cancel a Customer's Tea Subscription API Endpoint" do
  it "can cancel a customer subscription" do
    create_list(:customer, 3)
    create_list(:subscription, 3)

    subscription = Subscription.first
    customer = Customer.first

    expect(CustomerSubscription.all.length).to eq(0)

    post '/api/v0/customer_subscriptions', params: {subscription_id: subscription.id, customer_id: customer.id }

    expect(response).to be_successful
    expect(CustomerSubscription.all.length).to eq(1)
    expect(CustomerSubscription.all.first.status).to eq("active")

    patch "/api/v0/customer_subscriptions/cancel", params: {subscription_id: subscription.id, customer_id: customer.id }

    expect(response).to be_successful
    expect(CustomerSubscription.all.length).to eq(1)
    expect(CustomerSubscription.all.first.status).to eq("canceled")

    response_data = JSON.parse(response.body, symbolize_names: true)

    expect(response_data).to have_key(:message)
    expect(response_data[:message]).to be_a String
    expect(response_data[:message]).to eq("Customer ##{customer.id}'s subscription of #{subscription.title} has been canceled")
  end 


end