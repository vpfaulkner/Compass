class API::V1::LegislatorsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    @location = find_location
    unless @location
      render :text => "not a valid address", :status => 404
    else
      @legislators = Sunshine.new.search(@location)
      render json: @legislators
    end
  end

  def profile
    @profile = Sunshine.new.profile(legislator_params[:lastname], legislator_params[:state],  legislator_params[:title])
    render json:  @profile
  end

  private

  def find_location
    address = legislator_params[:address]
    location = Geocoder.coordinates(address)
  end

  def legislator_params
    params.permit(:address, :lastname, :state, :title)
  end

end
