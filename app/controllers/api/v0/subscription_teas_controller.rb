class Api::V0::SubscriptionTeasController < ApplicationController

  def create
    tea = Tea.find(params[:tea_id])
    subscription = Subscription.find(params[:subscription_id])

    if SubscriptionTea.find_by(tea_id: tea.id, subscription_id: subscription.id)
      subscription_tea_exists_response(tea.title, subscription.title)
    else
      subscription_tea = SubscriptionTea.new(tea_id: tea.id, subscription_id: subscription.id)
      if subscription_tea.save
        success_response(tea.title, subscription.title)
      end
    end
  end

  private
  def subscription_tea_exists_response(tea_title, subscription_title)
    render json: ErrorSerializer.new(
      ErrorMessage.new(
        "#{tea_title} tea is already part of #{subscription_title} subscription", 422
      )).serialize_json, status: 422
  end

  def success_response(tea_title, subscription_title)
    render json:  {
      "message": "Successfully added #{tea_title} tea to #{subscription_title} subscription"
    }, status: 201
  end
end