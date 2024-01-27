# README

# Tea Subscription Service
> This application handles requests for creating/updating customers and subscriptions and canceling subscriptions. 
- A subscription may be created, with subscriptions being sent out on a frequency outlined by the service this api is connected to; perhaps monthly, quarterly or annually. These subscriptions will also have titles and a status for availability (available, out of stock, unavailable).
-  Teas may be added to each subscription, with each tea being able to be added to multiple subscriptions. Teas have information including title, brew time, temperature and description.
- Customers can create accounts with a first name, last name, email and address.
- Customers may activate and cancel subscriptions.


## Installation

OS X & Linux:
This project runs on Rails 7.0.8.

Fork and clone [this repository](https://github.com/shawndcarpenter/tea_subscription).

Windows:

This product is not compatible with Windows.

## Local Set Up
Run the following code in your terminal to install the gems required to use this application:
```sh
bundle install
```

Run the following code in your terminal to set up the database:
```sh
rails db:{drop,create,migrate,seed}
```

Check to make sure all the tests are passing by running the following code in your terminal:
```sh
bundle exec rspec
```
# Database
The following models are available:

## Customers
A customer's data may be sent in using the following parameters.

- first_name: string
- last_name: string
- email: string
- address: string

Upon creation, a customer has no customer subscriptions.

## Subscriptions
A subscription may be created in the database using the following parameters.

- title: string
- price: float
- status: integer (set up as an enum with 0 = "available", 1 = "out_of_stock" and 2 = "unavailable")
- frequency: string

A theoretical front end service may create a variety of subscription options which each have their own titles, prices, and frequencies. The status may be set for a subscription whose items are out of stock; if more statuses are needed, they may be added in the enum in "app/models/subscription.rb".

## Customer Subscriptions
This is the joins table for subscriptions and customers. It includes the personal status of a customer's subscription.

- customer_id: integer
- subscription_id: integer
- status: integer (set up as an enum with 0 = "active" and 1 = "canceled")

A subscription can be linked to a customer using the customer_subscriptions joins table and the "Create a Customer Subscription" endpoint outlined in the Available Endpoints section of this README.

## Teas
- title: string
- description: string
- temperature: float
- brew_time: string

## Subscription Teas
This is a joins table that allows an application to add teas to a subscription.
- subscription_id: integer
- tea_id: integer

A subscription_tea object may be created using the "Create a Subscription Tea" endpoint outlined in the Available Endpoints section of this README.

## Gems
The [Shoulda Matchers Gem](https://github.com/thoughtbot/shoulda-matchers) is used for one-liner testing of models.

The [SimpleCov Gem](https://github.com/simplecov-ruby/simplecov) provides test coverage analysis for our application.

This application uses the [Pry gem](https://github.com/pry/pry) and [RSpec Rails](https://github.com/rspec/rspec-rails) within the testing environment for unit and feature testing.

The [FactoryBot](https://github.com/thoughtbot/factory_bot) and [Faker Gems](https://github.com/faker-ruby/faker) was used to create data for testing. 

## Available Endpoints
Each endpoint includes error messages for various situations, including missing parameters, customer/subscription not found, subscription already canceled and more.

### Create a Customer Subscription
This application provides users with the ability to create subscriptions and customers. A Customer Subscription includes the information for both the customer and their subscription.

*Application will receive the following input:*
```sh
  post "/api/v0/customer_subscriptions", params: {
                                        subscription_id:  subscription.id,      
                                        customer_id: customer.id }
```
*And return the following output:*

```sh
{:message=>"Successfully signed up Customer #2150 for European Mistletoe"}
```

### Cancel a Customer's Subscriptions

This endpoint will change the status of a subscription of a customer from active to canceled.

*Application will receive the following input:*
```sh
  patch "/api/v0/customer_subscriptions/cancel", params: {subscription_id: subscription.id, customer_id: customer.id }
```
*And return the following output:*

```sh
{:message=>"Customer #2272's subscription of Munnar has been canceled"}
```

### Get a Customer's Subscriptions

This endpoint returns both active and canceled subscriptions for one customer. A customer must exist, and if no subscriptions are active or canceled for a customer, "Customer ##{customer.id} does not have any active or canceled subscriptions" will be sent in a response message.

*Application will receive the following input:*
```sh
  get "/api/v0/customers/#{customer.id}/subscriptions"
```
*And return the following output:*

```sh
{:data=>
  [{:id=>"1748", 
    :type=>"subscription", 
    :attributes=>{:id=>1748, 
                    :title=>"Biluochun", 
                    :price=>25.74, 
                    :status=>"available", 
                    :frequency=>"Annual"}},
   {:id=>"1749", 
    :type=>"subscription", 
    :attributes=>{:id=>1749, 
                  :title=>"Daejak", 
                  :price=>55.14, 
                  :status=>"available", 
                  :frequency=>"Annual"}}]}
```
### Get All Teas
This endpoint will send back all teas saved in the database.

*Application will receive the following input:*
```sh
get "/api/v0/teas"
```
*And return the following output:*

```sh
{:data=>
  [{:id=>"154", 
    :type=>"tea", 
      :attributes=>{:id=>154, 
                    :title=>"Sencha", 
                    :description=>"Green", 
                    :temperature=>28.71, 
                    :brew_time=>"1 min 19 sec"}},
   {:id=>"155", 
   :type=>"tea", ...
```
### Create a Customer
This endpoint will receive a customer's data and send back the data for said customer. All parameters (first_name, last_name, email and address) must be passed in; an appropriate error message will be sent back for missing parameters.

*Application will receive the following input:*
```sh
post "/api/v0/customers", params: {customer: {first_name: "John",
                                              last_name: "Smith",
                                              email: "email@email.com",
                                              address: "123 Address Drive"}}
```
*And return the following output:*

```sh
{:data=>{:id=>"2096", 
        :type=>"customer", 
        :attributes=>{:first_name=>"John", 
                      :last_name=>"Smith", 
                      :email=>"email@email.com", 
                      :address=>"123 Address Drive"}}}
```

### Create a Subscription
This endpoint will receive the data for a specific subscription and return the subscription created. All parameters (title, price, status and frequency) must be passed in; an appropriate error message will be sent back for missing parameters.

*Application will receive the following input:*
```sh
post "/api/v0/subscriptions", params: {subscription: {
                                                  title: "Fujian New Craft",
                                                  price: 41.24,
                                                  status: "available",
                                                  frequency: "Daily"}}
```
*And return the following output:*

```sh
{:data=>{:id=>"1698", 
        :type=>"subscription", 
        :attributes=>{:id=>1698, 
                      :title=>"Fujian New Craft", 
                      :price=>41.24, 
                      :status=>"available", 
                      :frequency=>"Daily"}}}
```

### Update a Customer
This endpoint will receive a customer's data to be updated and send back the new data for said customer. Any parameters (first_name, last_name, email and address) MAY be passed in; an appropriate error message will be sent back for missing customer.

*Application will receive the following input:*
```sh
patch "/api/v0/customers/#{customer.id}", params: {customer: {address: "1234 New Address Drive"}}
```
*And return the following output:*

```sh
{:data=>
  {:id=>"2230",
   :type=>"customer",
   :attributes=>{:first_name=>"John", :last_name=>"Smith", :email=>"email@email.com", :address=>"1234 New Address Drive"}}}
```

### Update a Subscription
This endpoint will receive the data to be updated for a specific subscription and return the subscription created. Any parameters (title, price, status and frequency) MAY be passed in; an appropriate error message will be sent back for missing subscription.

*Application will receive the following input:*
```sh
patch "/api/v0/subscriptions/#{subscription.id}", params: {subscription: 
                                                          {price: 50.01
                                                          }}                
```
*And return the following output:*

```sh
{:data=>
  {:id=>"1813", 
  :type=>"subscription", 
  :attributes=>{:id=>1813, 
                :title=>"Fujian New Craft", 
                :price=>50.01, 
                :status=>"available", 
                :frequency=>"Daily"}}}
```

### Create a Subscription Tea

This application provides users with the ability to create subscriptions and teas. A Subscription Tea includes the information for both the tea and the subscription.

*Application will receive the following input:*
```sh
  post "/api/v0/subscription_teas", params: {
                                        subscription_id:  subscription.id,      
                                        tea_id: tea.id }
```
*And return the following output:*

```sh
{:message=>"Successfully added Earl Grey tea to European Mistletoe subscription"}
```

# Staff

Shawn Carpenter: [Email](shawncarpenter.co@gmail.com) [LinkedIn](https://www.linkedin.com/in/shawndcarpenter/)

## Contributing

1. Fork it (<https://github.com/shawndcarpenter/tea_subscription>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request