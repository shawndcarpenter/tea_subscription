class Api::V0::SubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

  def create
    subscription = Subscription.new(subscription_params)
    if subscription.save
      render json: SubscriptionSerializer.new(subscription), status: 201
    else
      render json: SubscriptionSerializer.new(Subscription.create!(subscription_params))
    end
  end

  private
  def subscription_params
    params.require(:subscription).permit(:title, :price, :frequency, :status)
  end

  def invalid_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 422))
    .serialize_json, status: 422
  end
end