class AddColumnToCustomerSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :customer_subscriptions, :status, :integer, default: 0
  end
end
