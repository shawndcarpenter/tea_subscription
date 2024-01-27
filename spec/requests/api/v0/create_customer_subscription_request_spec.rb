require 'rails_helper'

describe "Sign Up Customer for Tea Subscription API Endpoint" do
  it "creates a customer subscription" do
    subscription = create(:subscription)
    customer = create(:customer)

    expect(CustomerSubscription.all.length).to eq(0)

    post '/api/v0/customer_subscriptions', params: {subscription_id: subscription.id, customer_id: customer.id }

    expect(response).to be_successful
    expect(CustomerSubscription.all.length).to eq(1)

    response_data = JSON.parse(response.body, symbolize_names: true)

    expect(response_data).to have_key(:message)
    expect(response_data[:message]).to be_a String
    expect(response_data[:message]).to eq("Successfully signed up Customer ##{customer.id} for #{subscription.title}")
  end 

  describe "sad paths" do
    it "gracefully handles customer does not exist" do
      subscription = create(:subscription)

      expect(CustomerSubscription.all.length).to eq(0)

      post '/api/v0/customer_subscriptions', params: {subscription_id: subscription.id, customer_id: 123123123 }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Customer with 'id'=123123123")
    end

    it "gracefully handles subscription does not exist" do
      customer = create(:customer)

      expect(CustomerSubscription.all.length).to eq(0)

      post '/api/v0/customer_subscriptions', params: {subscription_id: 123123123, customer_id: customer.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Subscription with 'id'=123123123")
    end

    it "gracefully handles missing parameters" do
      customer = create(:customer)

      expect(CustomerSubscription.all.length).to eq(0)

      post '/api/v0/customer_subscriptions', params: {customer_id: customer.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Subscription without an ID")
    end

    it "gracefully handles no parameters" do
      customer = create(:customer)

      expect(CustomerSubscription.all.length).to eq(0)

      post '/api/v0/customer_subscriptions'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Customer without an ID")
    end

    it "gracefully handles customer already subscribed" do
      subscription = create(:subscription)
      customer = create(:customer)
  
      expect(CustomerSubscription.all.length).to eq(0)
  
      post '/api/v0/customer_subscriptions', params: {subscription_id: subscription.id, customer_id: customer.id }
  
      expect(response).to be_successful
      expect(CustomerSubscription.all.length).to eq(1)

      post '/api/v0/customer_subscriptions', params: {subscription_id: subscription.id, customer_id: customer.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Customer ##{customer.id} is already signed up for #{subscription.title}")
    end
  end
end