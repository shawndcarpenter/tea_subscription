require 'rails_helper'

describe "Create Customers API Endpoint" do
  it "creates a customer" do
    customer_params = ({first_name: "John",
    last_name: "Smith",
    email: "email@email.com",
    address: "123 Address Drive"})

    expect(Customer.all.length).to eq(0)

    post '/api/v0/customers', params: {customer: customer_params}
    
    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(data).to have_key(:id)

    customer = Customer.all.first

    expect(Customer.all.length).to eq(1)

    expect(customer.first_name).to eq("John")
    expect(customer.last_name).to eq("Smith")
    expect(customer.email).to eq("email@email.com")
    expect(customer.address).to eq("123 Address Drive")

    expect(data).to have_key(:id)
    expect(data[:id].to_i).to be_a Integer

    expect(data).to have_key(:type)
    expect(data[:type]).to eq("customer")

    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to be_a Hash

    expect(data[:attributes]).to have_key(:first_name)
    expect(data[:attributes][:first_name]).to be_a String

    expect(data[:attributes]).to have_key(:last_name)
    expect(data[:attributes][:last_name]).to be_a String

    expect(data[:attributes]).to have_key(:email)
    expect(data[:attributes][:email]).to be_a String

    expect(data[:attributes]).to have_key(:address)
    expect(data[:attributes][:address]).to be_a String
  end

  describe "sad paths" do
    it "must have all parameters" do
      customer_params = ({first_name: "John",
      last_name: "Smith",
      address: "123 Address Drive"})
  
      expect(Customer.all.length).to eq(0)
  
      post '/api/v0/customers', params: {customer: customer_params}
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(Customer.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Email can't be blank")
    end
  end
end