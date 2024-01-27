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

  describe "sad paths" do
    it "gracefully handles tea does not exist" do
      create_list(:subscription, 3)
      subscription = Subscription.first

      expect(SubscriptionTea.all.length).to eq(0)

      post '/api/v0/subscription_teas', params: {subscription_id: subscription.id, tea_id: 123123123 }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(SubscriptionTea.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Tea with 'id'=123123123")
    end

    it "gracefully handles subscription does not exist" do
      create_list(:tea, 3)
      tea = Tea.first

      expect(SubscriptionTea.all.length).to eq(0)

      post '/api/v0/subscription_teas', params: {subscription_id: 123123123, tea_id: tea.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(SubscriptionTea.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Subscription with 'id'=123123123")
    end

    it "gracefully handles missing parameters" do
      create_list(:tea, 3)
      tea = Tea.first

      expect(SubscriptionTea.all.length).to eq(0)

      post '/api/v0/subscription_teas', params: {tea_id: tea.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(SubscriptionTea.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Subscription without an ID")
    end

    it "gracefully handles no parameters" do
      create_list(:tea, 3)
      tea = Tea.first

      expect(SubscriptionTea.all.length).to eq(0)

      post '/api/v0/subscription_teas'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(SubscriptionTea.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Tea without an ID")
    end

    it "gracefully handles tea already subscribed" do
      create_list(:tea, 3)
      create_list(:subscription, 3)
  
      subscription = Subscription.first
      tea = Tea.first
  
      expect(SubscriptionTea.all.length).to eq(0)
  
      post '/api/v0/subscription_teas', params: {subscription_id: subscription.id, tea_id: tea.id }
  
      expect(response).to be_successful
      expect(SubscriptionTea.all.length).to eq(1)

      post '/api/v0/subscription_teas', params: {subscription_id: subscription.id, tea_id: tea.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(SubscriptionTea.all.length).to eq(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("#{tea.title} tea is already part of #{subscription.title} subscription")
    end
  end
end