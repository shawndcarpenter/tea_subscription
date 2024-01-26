class Tea < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :brew_time
  validates_presence_of :description
  validates_presence_of :temperature
end
