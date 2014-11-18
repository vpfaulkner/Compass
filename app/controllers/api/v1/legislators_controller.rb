class API::V1::LegislatorsController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    location = find_location
    unless location
      render { "not a valid address" }
    end

    my_json = { "legislators" => [{"first_name" => "John","last_name" => "Doe","role" => "Senator","State" => "NC","Party" => "Democrat","ID" => 1}, {"first_name" => "Jane","last_name" => "Smith","role" => "Representative","State" => "NC","Party" => "Republican","ID" => 2} ] }
    render json: my_json
  end

  def find_location
    address = legislator_params[:address]
    ip_address = legislator_params[:ip_address]
    location = Geocoder.coordinates(ip_address) if ip_address
    location = Geocoder.coordinates(address) if address
    location
  end

  def legislator_params
    params.permit(:address, :ip_address)
  end

end
