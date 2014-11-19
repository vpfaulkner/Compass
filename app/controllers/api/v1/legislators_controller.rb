class API::V1::LegislatorsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    @location = find_location
    unless @location
      render :text => "not a valid address", :status => 404
    else
      @legislators_json = Sunshine.search(@location)
      render json: @legislators_json
    end
  end

  def profile
    @sunshine_response = find_legislator
    @formatted_profile = Sunshine.profile(@sunshine_response)
    render json:  @formatted_profile
  end

  private

  def find_legislator
    lastname = legislator_params[:lastname]
    state = legislator_params[:state]
    title = legislator_params[:title]
    HTTParty.get('http://services.sunlightlabs.com/api/legislators.getList.json',
                query: {apikey: ENV['SUNLIGHT_KEY'],lastname: lastname, state: state}, title: title)
  end

  def find_location
    address = legislator_params[:address]
    location = Geocoder.coordinates(address)
  end

  def legislator_params
    params.permit(:address, :lastname, :state, :title)
  end

end
