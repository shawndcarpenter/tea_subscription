class Api::V0::CustomerSubscriptionsController < ApplicationController

  def index
    customer = Customer.find(params[:customer_id])
    subscriptions = customer.subscriptions
    if subscriptions == []
      no_subscriptions_response(customer.id)
    else
      render json: SubscriptionSerializer.new(subscriptions)
    end
  end

  def create
    customer = Customer.find(params[:customer_id])
    subscription = Subscription.find(params[:subscription_id])

    if CustomerSubscription.where("customer_id = #{customer.id} and subscription_id = #{subscription.id}") != []
      customer_already_subscribed_response(customer.id, subscription.title)
    else
      customer_subscription = CustomerSubscription.new(customer_id: customer.id, subscription_id: subscription.id)
      if customer_subscription.save
        success_response(customer.id, subscription.title)
      end
    end
  end

  def cancel
    customer = Customer.find(params[:customer_id])
    subscription = Subscription.find(params[:subscription_id])
    customer_subscription = CustomerSubscription.where("customer_id = #{customer.id} and subscription_id = #{subscription.id}").first

    if customer_subscription && customer_subscription.status != "canceled"
      customer_subscription.canceled!
      canceled_successfully_response(customer.id, subscription.title)
    elsif customer_subscription.status == "canceled"
      already_canceled_response(customer.id, subscription.title)
    end
  end

  private
  def no_subscriptions_response(customer_id)
    render json:  {
      "message": "Customer ##{customer_id} does not have any active or canceled subscriptions"
    }, status: 201
  end

  def success_response(customer_id, subscription_title)
    render json:  {
      "message": "Successfully signed up Customer ##{customer_id} for #{subscription_title}"
    }, status: 201
  end

  def already_canceled_response(customer_id, subscription_title)
    render json: ErrorSerializer.new(
      ErrorMessage.new(
        "Subscription of #{subscription_title} by Customer ##{customer_id} is already canceled", 404
      )).serialize_json, status: 404
  end

  def canceled_successfully_response(customer_id, subscription_title)
    render json:  {
      "message": "Customer ##{customer_id}'s subscription of #{subscription_title} has been canceled"
    }, status: 201
  end

  def customer_already_subscribed_response(customer_id, subscription_title)
    render json: ErrorSerializer.new(
      ErrorMessage.new(
        "Customer ##{customer_id} is already signed up for #{subscription_title}", 404
      )).serialize_json, status: 404
  end
end