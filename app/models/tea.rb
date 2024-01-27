class Tea < ApplicationRecord
  has_many :subscription_teas
  has_many :subscriptions, through: :subscription_teas

  validates_presence_of :title
  validates_presence_of :brew_time
  validates_presence_of :description
  validates_presence_of :temperature
end
