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

  describe "sad paths" do
    before :each do
      @subscription = create(:subscription)
      @customer = create(:customer)
      post '/api/v0/customer_subscriptions', params: {subscription_id: @subscription.id, customer_id: @customer.id }
      
      expect(CustomerSubscription.all.length).to eq(1)
    end

    it "gracefully handles customer does not exist" do
      patch "/api/v0/customer_subscriptions/cancel", params: {subscription_id: @subscription.id, customer_id: 123123123 }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Customer with 'id'=123123123")
    end

    it "gracefully handles subscription does not exist" do
      patch "/api/v0/customer_subscriptions/cancel", params: {subscription_id: 123123123, customer_id: @customer.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Subscription with 'id'=123123123")
    end

    it "gracefully handles missing parameters" do
      patch "/api/v0/customer_subscriptions/cancel", params: {customer_id: @customer.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Subscription without an ID")
    end

    it "gracefully handles no parameters" do
      patch "/api/v0/customer_subscriptions/cancel"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Customer without an ID")
    end

    it "gracefully handles customer already subscribed" do
      patch "/api/v0/customer_subscriptions/cancel", params: {subscription_id: @subscription.id, customer_id: @customer.id }
  
      expect(response).to be_successful
      expect(CustomerSubscription.all.length).to eq(1)

      patch "/api/v0/customer_subscriptions/cancel", params: {subscription_id: @subscription.id, customer_id: @customer.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(CustomerSubscription.all.length).to eq(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Subscription of #{@subscription.title} by Customer ##{@customer.id} is already canceled")
    end
  end
end