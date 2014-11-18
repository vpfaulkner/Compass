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
      my_json = { "legislators" => [{"first_name" => "John","last_name" => "Doe","role" => "Senator","State" => "NC","Party" => "Democrat","ID" => 1}, {"first_name" => "Jane","last_name" => "Smith","role" => "Representative","State" => "NC","Party" => "Republican","ID" => 2} ] }
      render json: my_json
    end
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
      # Push first name, role, state, party
      legislators.push(legislator["legislator"]["lastname"])
    end
    legislators
  end

  def legislator_params
    params.permit(:address)
  end

end
