class API::V1::LegislatorsController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    location = find_location

    unless location
      render :text => "not a valid address", :status => 404
    else

    my_json = { "legislators" => [{"first_name" => "John","last_name" => "Doe","role" => "Senator","State" => "NC","Party" => "Democrat","ID" => 1}, {"first_name" => "Jane","last_name" => "Smith","role" => "Representative","State" => "NC","Party" => "Republican","ID" => 2} ] }
    render json: my_json
    end
  end

  def find_location
    address = legislator_params[:address]
    location = Geocoder.coordinates(address)
  end

  def legislator_params
    params.permit(:address)
  end

end
