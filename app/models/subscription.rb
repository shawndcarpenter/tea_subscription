class Subscription < ApplicationRecord
  has_many :customer_subscriptions
  has_many :customers, through: :customer_subscriptions

  validates_presence_of :title
  validates_presence_of :status
  validates_presence_of :price
  validates_presence_of :frequency

  enum status: {
    available: 0,
    out_of_stock: 1,
    unavailable: 2
  }
end
