class API::V1::LegislatorsController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def search
    my_json = { "legislators" => [{"first_name" => "John","last_name" => "Doe","role" => "Senator","State" => "NC","Party" => "Democrat","ID" => 1}, {"first_name" => "Jane","last_name" => "Smith","role" => "Representative","State" => "NC","Party" => "Republican","ID" => 2} ] }
    render json: my_json
  end

end
