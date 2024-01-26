class CustomerSubscription < ApplicationRecord
  belongs_to :customer
  belongs_to :subscription

  validates_presence_of :customer_id
  validates_presence_of :subscription_id

  enum status: {
    active: 0,
    canceled: 1
  }
end