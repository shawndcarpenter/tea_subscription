class Api::V0::CustomersController < ApplicationController

  def create
    customer = Customer.new(customer_params)
    if customer.save
      render json: CustomerSerializer.new(customer), status: 201
    else
      render json: CustomerSerializer.new(Customer.create!(customer_params))
    end
  end

  def update
    customer = Customer.find(params[:id])
    customer.update!(customer_params)
    customer.save

    render json: CustomerSerializer.new(customer)
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :address)
  end
end