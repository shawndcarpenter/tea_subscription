require 'rails_helper'

describe "Get Customer Tea Subscriptions API Endpoint" do
  it "creates a customer subscription" do
    create_list(:customer, 3)
    create_list(:subscription, 3)

    subscription = Subscription.first
    subscription_2 = Subscription.all[1]
    @subscription_3 = Subscription.last
    customer = Customer.first
    customer_2 = Customer.all[1]

    expect(CustomerSubscription.all.length).to eq(0)

    post '/api/v0/customer_subscriptions', params: {subscription_id: subscription.id, customer_id: customer.id }
    
    expect(response).to be_successful

    post '/api/v0/customer_subscriptions', params: {subscription_id: subscription_2.id, customer_id: customer.id }
    
    expect(response).to be_successful

    post '/api/v0/customer_subscriptions', params: {subscription_id: @subscription_3.id, customer_id: customer_2.id }
    
    expect(response).to be_successful

    expect(CustomerSubscription.all.length).to eq(3)
    expect(customer.subscriptions.length).to eq(2)

    get "/api/v0/customers/#{customer.id}/subscriptions"

    expect(response).to be_successful

    subscriptions = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(subscriptions.length).to eq(2)

    subscriptions.each do |subscription|
      expect(subscription).to have_key(:id)
      expect(subscription[:id].to_i).to be_a Integer
      expect(subscription[:id]).to_not eq(@subscription_3.id)

      expect(subscription).to have_key(:type)
      expect(subscription[:type]).to eq("subscription")

      expect(subscription).to have_key(:attributes)
      expect(subscription[:attributes]).to be_a Hash

      expect(subscription[:attributes]).to have_key(:title)
      expect(subscription[:attributes][:title]).to be_a String

      expect(subscription[:attributes]).to have_key(:price)
      expect(subscription[:attributes][:price]).to be_a Float

      expect(subscription[:attributes]).to have_key(:status)
      expect(subscription[:attributes][:status]).to be_a Integer

      expect(subscription[:attributes]).to have_key(:frequency)
      expect(subscription[:attributes][:frequency]).to be_a String
    end
  end 
end