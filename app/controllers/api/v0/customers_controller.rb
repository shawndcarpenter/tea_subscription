class Api::V0::CustomersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

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
    # binding.pry
    render json: CustomerSerializer.new(customer)
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :address)
  end

  def invalid_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 422))
    .serialize_json, status: 422
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: 404
  end
end