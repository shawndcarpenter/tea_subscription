class Api::V0::CustomerSubscriptionsController < ApplicationController
  def create
    customer = Customer.find(params[:customer_id])
    subscription = Subscription.find(params[:subscription_id])
    customer_subscription = CustomerSubscription.new(customer_id: customer.id, subscription_id: subscription.id)
    if customer_subscription.save
      success_response(customer.id, subscription.title)
    end
  end

  private
  def success_response(customer_id, subscription_title)
    render json:  {
      "message": "Successfully signed up Customer ##{customer_id} for #{subscription_title}"
    }, status: 201
  end
end