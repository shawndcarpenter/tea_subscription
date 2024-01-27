require 'rails_helper'

describe "Create Subscriptions API Endpoint" do
  it "creates a subscription" do
    subscription_params = ({title: "Fujian New Craft",
    price: 41.24,
    status: "available",
    frequency: "Daily"})

    expect(Subscription.all.length).to eq(0)

    post '/api/v0/subscriptions', params: {subscription: subscription_params}
    
    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)[:data]

    subscription = Subscription.all.first

    expect(Subscription.all.length).to eq(1)

    expect(subscription.title).to eq("Fujian New Craft")
    expect(subscription.price).to eq(41.24)
    expect(subscription.status).to eq("available")
    expect(subscription.frequency).to eq("Daily")

    expect(data).to have_key(:id)
    expect(data[:id].to_i).to be_a Integer

    expect(data).to have_key(:type)
    expect(data[:type]).to eq("subscription")

    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to be_a Hash

    expect(data[:attributes]).to have_key(:title)
    expect(data[:attributes][:title]).to be_a String

    expect(data[:attributes]).to have_key(:price)
    expect(data[:attributes][:price]).to be_a Float

    expect(data[:attributes]).to have_key(:status)
    expect(data[:attributes][:status]).to be_a String

    expect(data[:attributes]).to have_key(:frequency)
    expect(data[:attributes][:frequency]).to be_a String
  end

  describe "sad paths" do
    it "must have all parameters" do
      subscription_params = ({title: "Fujian New Craft",
      status: "available",
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