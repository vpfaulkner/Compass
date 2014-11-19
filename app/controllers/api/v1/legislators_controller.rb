class API::V1::LegislatorsController < ApplicationController
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

  def profile
    @sunshine_response = find_legislator
    @formatted_profile = format_profile_json(@sunshine_response)
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

  def format_profile_json(sunshine_response)
    legislators = Array.new
    sunshine_response["response"]["legislators"].each do |legislator|
      legislator_hash = Hash.new
      legislator_hash["firstname"] = legislator["legislator"]["firstname"]
      legislator_hash["lastname"] = legislator["legislator"]["lastname"]
      legislator_hash["state"] = legislator["legislator"]["state"]
      legislator_hash["party"] = legislator["legislator"]["party"]
      legislator_hash["website"] = legislator["legislator"]["website"]
      legislator_hash["middlename"] = legislator["legislator"]["middlename"]
      legislator_hash["phone"] = legislator["legislator"]["phone"]
      legislator_hash["district"] = legislator["legislator"]["district"]
      legislator_hash["twitter_id"] = legislator["legislator"]["twitter_id"]
      legislators.push(legislator_hash)
    end
    # push photo
    json = Hash.new
    json["legislators"] = legislators
    json
  end

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
    json = Hash.new
    json["legislators"] = legislators
    json
  end

  def legislator_params
    params.permit(:address, :lastname, :state, :title)
  end

end
