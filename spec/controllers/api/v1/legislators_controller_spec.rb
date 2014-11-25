require 'rails_helper'

RSpec.describe API::V1::LegislatorsController, :type => :controller do

  describe "GET #search" do

    it "responds successfully with an HTTP 200 status code" do
      get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders JSON" do
      get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }
      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)).not_to be_nil
    end

    it "finds Burr, Hagan, and Butterfield" do
      get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }
      expect(JSON.parse(response.body)["legislators"][0]["lastname"]).to eq("Burr")
      expect(JSON.parse(response.body)["legislators"][1]["lastname"]).to eq("Hagan")
      expect(JSON.parse(response.body)["legislators"][2]["lastname"]).to eq("Butterfield")
    end

    it "returns message if address is invalid" do
      get :search, { address: "" }
      expect(response.body).to eq("{\"Error\":\"not a valid address\"}")
    end

  end

  describe "GET #profile" do

    it "responds successfully with an HTTP 200 status code" do
      get :profile, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders JSON" do
      get :profile, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)).not_to be_nil
    end

    it "finds Burr's Twitter and ideology rank" do
      get :profile, { lastname: "Burr", state: "NC", title: "sen" }
      expect(JSON.parse(response.body)["legislators"][0]["twitter_id"]).to eq("SenatorBurr")
      expect(JSON.parse(response.body)["legislators"][0]["ideology_rank"]).to eq(84)
    end

    it "returns no legislators if invalid search" do
      get :profile, { lastname: "Burrz", state: "NC", title: "sen" }
      expect(response.body).to eq("{\"legislators\":[]}")
    end

  end

  describe "Get #funding" do

    # it "responds successfully with an HTTP 200 status code" do
    #   get :funding, { bioguide_id: "B001135" }
    #   expect(response).to be_success
    #   expect(response).to have_http_status(200)
    # end

  #   it "assigns a legislator_entity_id" do
  #     get :funding, { bioguide_id: "B001135" }
  #     expect(assigns(:legislator_entity_id)).to eq("2c44128cb0a74cb28409b806aee12aef")
  #   end
  #
  #   it "assigns funding_industries" do
  #     get :funding, { bioguide_id: "B001135" }
  #     expect(assigns(:funding_industries)).not_to be_nil
  #   end

  end

end
