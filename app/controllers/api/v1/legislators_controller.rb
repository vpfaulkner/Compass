class API::V1::LegislatorsController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def search
    render json: {message: 'Resource not found'}
  end

end
