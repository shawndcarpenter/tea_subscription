require 'rails_helper'

describe "Update customers API Endpoint" do
  it "updates a customer" do
    customer_params = ({first_name: "John",
    last_name: "Smith",
    email: "email@email.com",
    address: "123 Address Drive"})

    expect(Customer.all.length).to eq(0)

    post '/api/v0/customers', params: {customer: customer_params}
    
    expect(response).to be_successful
    customer = Customer.all.first

    patch "/api/v0/customers/#{customer.id}", params: {customer: {address: "1234 New Address Drive"}}

    data = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(Customer.all.length).to eq(1)

    customer = Customer.all.first

    expect(customer.first_name).to eq("John")
    expect(customer.last_name).to eq("Smith")
    expect(customer.email).to eq("email@email.com")
    expect(customer.address).to eq("1234 New Address Drive")
  end 

  describe "sad paths" do
    it "must have exist" do
      patch "/api/v0/customers/123123123", params: {customer: {price: 50.01}}
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(Customer.all.length).to eq(0)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Customer with 'id'=123123123")
    end
  end
end