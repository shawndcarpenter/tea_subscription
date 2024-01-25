require 'rails_helper'

describe "Tea API" do
  it "sends tea options" do
    create_list(:tea, 3)

    get '/api/v0/teas'

    expect(response).to be_successful

    teas = JSON.parse(response.body, symbolize_names: true)[:data]
    # binding.pry
    expect(teas.count).to eq(3)

    teas.each do |tea|
      expect(tea).to have_key(:id)
      expect(tea[:id].to_i).to be_a Integer

      expect(tea).to have_key(:type)
      expect(tea[:type]).to eq("tea")

      expect(tea).to have_key(:attributes)
      expect(tea[:attributes]).to be_a Hash

      expect(tea[:attributes]).to have_key(:title)
      expect(tea[:attributes][:title]).to be_a String

      expect(tea[:attributes]).to have_key(:description)
      expect(tea[:attributes][:description]).to be_a String

      expect(tea[:attributes]).to have_key(:temperature)
      expect(tea[:attributes][:temperature]).to be_a Float

      expect(tea[:attributes]).to have_key(:brew_time)
      expect(tea[:attributes][:brew_time]).to be_a String
    end
  end
end