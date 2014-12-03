require 'rails_helper'

RSpec.describe API::V1::LegislatorsController, :type => :controller do

  describe "GET #search" do

    it "responds successfully" do
      get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }

      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)).not_to be_nil

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

    it "responds successfully" do
      get :profile, { lastname: "Burr", state: "NC", title: "sen" }

      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)).not_to be_nil

      expect(JSON.parse(response.body)["legislators"][0]["twitter_id"]).to eq("SenatorBurr")
      expect(JSON.parse(response.body)["legislators"][0]["ideology_rank"]).to eq(30)

    end

    it "returns no legislators if invalid search" do
      get :profile, { lastname: "Burrz", state: "NC", title: "sen" }
      expect(response.body).to eq("{\"legislators\":[]}")
    end

  end

  describe "Get #funding_timeline" do

    it "responds successfully with an HTTP 200 status code" do
      get :funding_timeline, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(JSON.parse(response.body)["legislators"][0]["campaign_finance_hash"]["2002"]).to eq(1132900)
    end

  end

  describe "Get #elections_timeline" do

    it "responds successfully with an HTTP 200 status code" do
      get :elections_timeline, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(JSON.parse(response.body)["legislators"][0]["elections_timeline_array"][0]["start"]).to eq("1995-01-04")
    end

  end

  describe "Get #contributors_by_sector" do

    it "responds successfully with an HTTP 200 status code" do
      get :contributors_by_sector, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(JSON.parse(response.body)["legislators"][0]["contributors_by_sector"][0]["sector"]).not_to be_nil
    end

  end

  describe "Get #contributors_by_type" do

    it "responds successfully with an HTTP 200 status code" do
      get :contributors_by_type, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(JSON.parse(response.body)["legislators"][0]["contributors_by_type"]["Individuals"]).not_to be_nil
    end

  end

  describe "Get #top_contributors" do

    it "responds successfully with an HTTP 200 status code" do
      get :top_contributors, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)

      expect(JSON.parse(response.body)["legislators"][0]["top_contributors"].first["name"]).not_to be_nil
    end

  end

  describe "Get #funding_score_by_category" do

    it "responds successfully with an HTTP 200 status code" do
      get :funding_score_by_category, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)

      # expect(JSON.parse(response.body)["legislators"][0]["top_contributors"].first["name"]).not_to be_nil
    end

  end

  describe "Get #voting_score_by_category" do

    it "responds successfully with an HTTP 200 status code" do
      get :voting_score_by_category, { lastname: "Burr", state: "NC", title: "sen" }
      expect(response).to be_success
      expect(response).to have_http_status(200)

      # expect(JSON.parse(response.body)["legislators"][0]["top_contributors"].first["name"]).not_to be_nil
    end

  end

end
