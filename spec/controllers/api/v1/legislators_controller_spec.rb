require 'rails_helper'

RSpec.describe API::V1::LegislatorsController, :type => :controller do

  describe "GET #search" do
    it "responds successfully with an HTTP 200 status code" do
      get :search
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end


end
