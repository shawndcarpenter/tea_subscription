class Api::V0::SubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def create
    subscription = Subscription.new(subscription_params)
    if subscription.save
      render json: SubscriptionSerializer.new(subscription), status: 201
    else
      render json: SubscriptionSerializer.new(Subscription.create!(subscription_params))
    end
  end

  def update
    subscription = Subscription.find(params[:id])
    subscription.update!(subscription_params)
    subscription.save
    # binding.pry
    render json: SubscriptionSerializer.new(subscription)
  end

  private
  def subscription_params
    params.require(:subscription).permit(:title, :price, :frequency, :status)
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