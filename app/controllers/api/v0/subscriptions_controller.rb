class Api::V0::SubscriptionsController < ApplicationController

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
   
    render json: SubscriptionSerializer.new(subscription)
  end

  private
  def subscription_params
    params.require(:subscription).permit(:title, :price, :frequency, :status)
  end
end