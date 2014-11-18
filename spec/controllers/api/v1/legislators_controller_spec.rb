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

    it "assigns a location with address" do
      get :search, { address: "208 W. Lavendar Ave, Durham, NC 27704" }
      expect(assigns(:location))
    end

    it "returns message if address is invalid" do
      get :search, { address: "" }
      expect(response.body).to eq("not a valid address")
    end

  end


end
