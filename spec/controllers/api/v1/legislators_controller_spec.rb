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
  #
  #   it "assigns a location with address" do
  #     get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }
  #     expect(assigns(:location)).not_to be_nil
  #   end
  #
  #   it "returns message if address is invalid" do
  #     get :search, { address: "" }
  #     expect(response.body).to eq("not a valid address")
  #   end
  #
  #   it "assigns legislator_json" do
  #     get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }
  #     expect(assigns(:legislators)).not_to be_nil
  #   end
  #
  #   it "finds Burr, Hagan, and Butterfield" do
  #     get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }
  #     expect(assigns(:legislators)["legislators"][0]["lastname"]).to eq("Burr")
  #     expect(assigns(:legislators)["legislators"][1]["lastname"]).to eq("Hagan")
  #     expect(assigns(:legislators)["legislators"][2]["lastname"]).to eq("Butterfield")
  #   end
  #
  # end
  #
  # describe "GET #profile" do
  #
  #   it "responds successfully with an HTTP 200 status code" do
  #     get :profile, { lastname: "Burr", state: "NC", title: "sen" }
  #     expect(response).to be_success
  #     expect(response).to have_http_status(200)
  #   end
  #
  #   it "renders JSON" do
  #     get :profile, { lastname: "Burr", state: "NC", title: "sen" }
  #     expect(response.header['Content-Type']).to include 'application/json'
  #     expect(JSON.parse(response.body)).not_to be_nil
  #   end
  #
  #   it "assigns a profile" do
  #     get :profile, { lastname: "Burr", state: "NC", title: "sen" }
  #     expect(assigns(:profile)).not_to be_nil
  #   end
  #
  #   it "returns message if address is invalid" do
  #     get :profile, { lastname: "Burrz", state: "NC", title: "sen" }
  #     expect(response.body).to eq("no legislators match this query")
  #   end
  #
  #   it "finds Burr's Twitter" do
  #     get :profile, { lastname: "Burr", state: "NC", title: "sen" }
  #     expect(assigns(:profile)["legislators"][0]["twitter_id"]).to eq("SenatorBurr")
  #   end
  #
  # end
  #
  # describe "Get #funding" do
  #
  #   it "responds successfully with an HTTP 200 status code" do
  #     get :funding, { bioguide_id: "B001135" }
  #     expect(response).to be_success
  #     expect(response).to have_http_status(200)
  #   end
  #
  #   it "assigns a legislator_entity_id" do
  #     get :funding, { bioguide_id: "B001135" }
  #     expect(assigns(:legislator_entity_id)).to eq("2c44128cb0a74cb28409b806aee12aef")
  #   end
  #
  #   it "assigns funding_industries" do
  #     get :funding, { bioguide_id: "B001135" }
  #     expect(assigns(:funding_industries)).not_to be_nil
  #   end
  #
  end

end
