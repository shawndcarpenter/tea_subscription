require 'rails_helper'

describe "Create Subscriptions API Endpoint" do
  it "creates a subscription" do
    subscription_params = ({title: "Fujian New Craft",
    price: 41.24,
    status: 0,
    frequency: "Daily"})

    expect(Subscription.all.length).to eq(0)

    post '/api/v0/subscriptions', params: {subscription: subscription_params}
    
    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)[:data]

    subscription = Subscription.all.first

    expect(Subscription.all.length).to eq(1)

    expect(subscription.title).to eq("Fujian New Craft")
    expect(subscription.price).to eq(41.24)
    expect(subscription.status).to eq(0)
    expect(subscription.frequency).to eq("Daily")
  end 

  describe "sad paths" do
    it "must have all parameters" do
      subscription_params = ({title: "Fujian New Craft",
      status: 0,
      frequency: "Daily"})
  
      expect(Subscription.all.length).to eq(0)
  
      post '/api/v0/subscriptions', params: {subscription: subscription_params}
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(Subscription.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Price can't be blank")
    end
  end
end