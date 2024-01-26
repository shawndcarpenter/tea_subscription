require 'rails_helper'

describe "Update Subscriptions API Endpoint" do
  it "updates a subscription" do
    subscription_params = ({title: "Fujian New Craft",
    price: 41.24,
    status: "available",
    frequency: "Daily"})

    expect(Subscription.all.length).to eq(0)

    post '/api/v0/subscriptions', params: {subscription: subscription_params}
    
    expect(response).to be_successful
    subscription = Subscription.all.first

    patch "/api/v0/subscriptions/#{subscription.id}", params: {subscription: {price: 50.01}}

    data = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(Subscription.all.length).to eq(1)

    subscription = Subscription.all.first

    expect(subscription.title).to eq("Fujian New Craft")
    expect(subscription.price).to eq(50.01)
    expect(subscription.status).to eq("available")
    expect(subscription.frequency).to eq("Daily")
  end 

  describe "sad paths" do
    it "must have exist" do
      patch "/api/v0/subscriptions/123123123", params: {subscription: {price: 50.01}}
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(Subscription.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Subscription with 'id'=123123123")
    end
  end
end