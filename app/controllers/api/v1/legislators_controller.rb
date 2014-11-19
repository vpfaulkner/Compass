class API::V1::LegislatorsController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    @location = find_location
    unless @location
      render :text => "not a valid address", :status => 404
    else
      @sunshine_response = get_legislators(@location)
      @legislators_json = format_legislator_json(@sunshine_response)
      render json: @legislators_json
    end
  end

  private

  def find_location
    address = legislator_params[:address]
    location = Geocoder.coordinates(address)
  end

  def get_legislators(location)
    latitude = location[0]
    longitude = location[1]
    HTTParty.get('http://services.sunlightlabs.com/api/legislators.allForLatLong.json',
                query: {apikey: ENV['SUNLIGHT_KEY'],latitude: latitude, longitude: longitude},)
  end

  def format_legislator_json(sunshine_response)
    json = Hash.new
    legislators = Array.new
    sunshine_response["response"]["legislators"].each do |legislator|
      legislator_hash = Hash.new
      legislator_hash["firstname"] = legislator["legislator"]["firstname"]
      legislator_hash["lastname"] = legislator["legislator"]["lastname"]
      legislator_hash["state"] = legislator["legislator"]["state"]
      legislator_hash["party"] = legislator["legislator"]["party"]
      legislator_hash["role"] = legislator["legislator"]["title"]
      legislators.push(legislator_hash)
    end
    json["legislators"] = legislators
    json
  end

  def legislator_params
    params.permit(:address)
  end

end
